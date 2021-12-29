data "amazon-ami" "ubuntu" {
  filters = {
    name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  owners      = ["099720109477"]
  most_recent = true
}

locals {
  # 빌드 시각 체크 및 버전 매칭
  create_at = timestamp()
  version   = formatdate("YYYYMMDDhhmm", local.create_at)
  ami_name = join("/", [
    "ubuntu",
    "20.04",
    "amd64",
    "${var.name}-${local.version}"
  ])
  # packer 의 source ami 기록
  source_tags = {
    "source-ami.packer.io/id"         = "{{ .SourceAMI }}"
    "source-ami.packer.io/name"       = "{{ .SourceAMIName }}"
    "source-ami.packer.io/owner-id"   = "{{ .SourceAMIOwner }}"
    "source-ami.packer.io/owner-name" = "{{ .SourceAMIOwnerName }}"
    "source-ami.packer.io/created-at" = "{{ .SourceAMICreationDate }}"
  }
  # build 정보 기록
  build_tags = {
    "build.packer.io/name"       = var.name
    "build.packer.io/version"    = local.version
    "build.packer.io/os"         = "ubuntu"
    "build.packer.io/os-version" = "20.04"
    "build.packer.io/region"     = "{{ .BuildRegion }}"
    "build.packer.io/created-at" = local.create_at
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name        = local.ami_name
  ami_description = var.description
  source_ami      = data.amazon-ami.ubuntu.id

  instance_type = "t2.micro"
  region        = "ap-northeast-2"
  ssh_username  = "ubuntu"

  # 빌드 과정 리소스에 붙는 태그
  run_tags = merge(
    local.source_tags,
    local.build_tags,
    {
      "Name" = "packer-build/${local.ami_name}"
    }
  )
  
  # ami 에 붙는 태그
  tags = merge(
    local.source_tags,
    local.build_tags,
    {
      "Name" = local.ami_name,
    }
  )
}
