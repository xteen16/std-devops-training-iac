provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_instance" "ubuntu" {
  ami           = "ami-04876f29fd3a5e8ba"
  instance_type = "t2.micro"

  tags = {
    Name = "fc-ubuntu"
  }
}
