provider "aws" {
  region = "ap-northeast-2"
}

/*
 * Groups
 */

resource "aws_iam_group" "developer" {
  name = "developer"
}

resource "aws_iam_group" "employee" {
  name = "employee"
}

output "groups" {
  value = [
    aws_iam_group.developer,
    aws_iam_group.employee,
  ]
}

/*
 * Users
 */

variable "users" {
  type = list(any)
}

resource "aws_iam_user" "this" {
  for_each = {
    for user in var.users :
    user.name => user
  }

  name = each.key

  tags = {
    level = each.value.level
    role  = each.value.role
  }
}

resource "aws_iam_user_group_membership" "this" {
  for_each = {
    for user in var.users :
    user.name => user
  }

  user   = each.key
  groups = each.value.is_developer ? [aws_iam_group.developer.name, aws_iam_group.employee.name] : [aws_iam_group.employee.name]
}

