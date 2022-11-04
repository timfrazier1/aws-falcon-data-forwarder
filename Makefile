TEMPLATE_FILE=template.yml
OUTPUT_FILE=sam.yml
FUNCTIONS=build/main

init: verify-aws-profile-set terraform/main.tf	## Initialize enterprise owned S3 infrastructure.
	AWS_PROFILE=${AWS_PROFILE} terraform -chdir=terraform init 

plan: verify-aws-profile-set init		## Plan the changes to infra.
	AWS_PROFILE=${AWS_PROFILE} terraform -chdir=terraform plan

apply: verify-aws-profile-set init		## Apply the changes in plan.
	AWS_PROFILE=${AWS_PROFILE} terraform -chdir=terraform apply 

output: verify-aws-profile-set apply		## See the output and put into the newconfig file.
	@# AWS_PROFILE=${AWS_PROFILE} terraform -chdir=terraform output -json | jq 'keys[] as $$k | "\($$k):\(.[$$k] | .value)"' | sed 's/:/": "/' | sed '$$!s/$$/,/'
	@jq '.RoleArn = $(shell terraform -chdir=terraform output RoleArn)' ./baseconfig.json > tmp 
	@cat tmp > newconfig.json
	@jq '.CodeS3Bucket = $(shell terraform -chdir=terraform output CodeS3Bucket)' ./newconfig.json > tmp
	@cat tmp > newconfig.json
	@jq '.S3Bucket = $(shell terraform -chdir=terraform output S3Bucket)' ./newconfig.json > tmp
	@cat tmp > newconfig.json
	@jq '.SecretArn = $(shell terraform -chdir=terraform output SecretArn)' ./newconfig.json > tmp
	@cat tmp > newconfig.json


destroy: verify-aws-profile-set 	## Destroy Infrastructure built with Terraform.
	AWS_PROFILE=${AWS_PROFILE} terraform -chdir=terraform destroy

build/helper: helper/*.go output
	go build -o build/helper ./helper/

build/main: ./*.go
	env GOARCH=amd64 GOOS=linux go build -o build/main .

clean:
	rm $(FUNCTIONS)

test:
	go test -v ./lib/

sam.yml: $(TEMPLATE_FILE) $(FUNCTIONS) build/helper 
	aws cloudformation package \
		--region $(shell ./build/helper get Region) \
		--template-file $(TEMPLATE_FILE) \
		--s3-bucket $(shell ./build/helper get CodeS3Bucket) \
		--s3-prefix $(shell ./build/helper get CodeS3Prefix) \
		--output-template-file $(OUTPUT_FILE)

deploy: $(OUTPUT_FILE) build/helper
	aws cloudformation deploy \
		--region $(shell ./build/helper get Region) \
		--template-file $(OUTPUT_FILE) \
		--stack-name $(shell ./build/helper get StackName) \
		--capabilities CAPABILITY_IAM $(shell ./build/helper mkparam)

verify-aws-profile-set:
ifndef AWS_PROFILE
	$(error AWS_PROFILE is not defined. Make sure that you set your AWS profile and region.)
endif
