provider "local" {
}

provider "aws" {
  region = "ap-northeast-2"
}

resource "local_file" "foo" {
  # path.module 은 .tf 파일이 위치한 경로
  filename = "${path.module}/foo.txt"
  content  = "Hello World!" 
}

data "local_file" "bar" {
  filename = "${path.module}/bar.txt"
}

output "file_bar" {
  value = data.local_file.bar
}

resource "aws_vpc" "foo" {
  // cidr_block = "10.0.0.0/16"
  # cidr_block 같은 option 을 변경할 경우 terraform 이 
  # resource 를 삭제한 뒤 재생성한다.
  cidr_block = "10.123.0.0/16"

  tags = {
    "Name" = "This is test vpc"
  }
}

output "vpc_foo" {
  value = aws_vpc.foo
}
