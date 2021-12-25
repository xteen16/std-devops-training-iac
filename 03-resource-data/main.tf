provider "aws" {
  region = "ap-northeast-2"
}

data "aws_ami" "ubuntu" {
  # return 되는 여러 ami 이미지 중 최신 이미지를 사용한다.
  most_recent = true

  # ubuntu 20.04 의 모든 ami 이미지를 가져온다. 
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  # 가상화 타입이 hvm 인 이미지
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # Canonical(ubuntu provider) 이 제작한 ami
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.image_id
  instance_type = "t2.micro"

  tags = {
    Name = "fc-ubuntu"
  }
}
