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
