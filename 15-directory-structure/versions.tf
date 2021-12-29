# .terraform-version 파일은  tfenv 를 위한 파일
# versions.tf 파일은 코드 내에 버전을 정의하기 위한 파일
terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
