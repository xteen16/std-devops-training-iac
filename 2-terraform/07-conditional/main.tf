provider "aws" {
  region = "ap-northeast-2"
}

/*
 * Conditional Expression
 * Condition ? If_True : If_False
 */

variable "is_john" {
  type    = bool
  default = true
}

locals {
  message = var.is_john ? "Hello John!" : "Hello!"
}

output "message" {
  value = local.message
}


/*
 * Count Trick for Conditional Resource
 */
variable "internet_gateway_enabled" {
  type    = bool
  default = true
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "this" {
  # internet gateway 변수에 따라서 해당 resource 를 생성한다.
  count = var.internet_gateway_enabled ? 1 : 0

  vpc_id = aws_vpc.this.id
}
