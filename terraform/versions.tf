terraform {
  required_version = ">= 0.15"

  required_providers {
    aws = ">= 3.0"
    snowflake = {
      source = "Snowflake-Labs/snowflake"
      version = "~> 0.35"
    }
  }
}
