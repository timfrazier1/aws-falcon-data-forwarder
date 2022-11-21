TEMPLATE_FILE=template.yml
OUTPUT_FILE=sam.yml
FUNCTIONS=build/main

init: terraform/main.tf	## Initialize enterprise owned S3 infrastructure.
	terraform -chdir=terraform init 

plan: init		## Plan the changes to infra.
	terraform -chdir=terraform plan

apply: init		## Apply the changes in plan.
	terraform -chdir=terraform apply 

 ## AWS_PROFILE=${AWS_PROFILE} terraform -chdir=terraform output -json | jq 'keys[] as $$k | "\($$k):\(.[$$k] | .value)"' | sed 's/:/": "/' | sed '$$!s/$$/,/'

output: 
	terraform -chdir=terraform output

make_config: apply		## See the output and put into the newconfig file.
	@jq '.RoleArn = $(shell terraform -chdir=terraform output RoleArn)' ./baseconfig.json > tmp 
	@cat tmp > newconfig.json
	@jq '.CodeS3Bucket = $(shell terraform -chdir=terraform output CodeS3Bucket)' ./newconfig.json > tmp
	@cat tmp > newconfig.json
	@jq '.S3Bucket = $(shell terraform -chdir=terraform output S3Bucket)' ./newconfig.json > tmp
	@cat tmp > newconfig.json
	@jq '.SecretArn = $(shell terraform -chdir=terraform output SecretArn)' ./newconfig.json > tmp
	@cat tmp > newconfig.json
	@rm tmp

destroy: 	## Destroy Infrastructure built with Terraform.
	terraform -chdir=terraform destroy
	rm -f sam.yml
	aws cloudformation delete-stack --stack-name $(shell ./build/helper get StackName) --region $(shell ./build/helper get Region)

build/helper: helper/*.go make_config
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
