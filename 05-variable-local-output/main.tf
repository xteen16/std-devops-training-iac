provider "aws" {
  region = "ap-northeast-2"
}

variable "vpc_name" {
  description = "생성되는 vpc 이름"
  type        = string
  default     = "default"
}

locals {
  common_tags = {
    Project = "Network"
    Owner   = "padella"
  }
}

output "vpc_name" {
  description = "생성된 vpc 의 이름"
  value       = module.vpc.name
}

output "vpc_id" {
  description = "생성된 vpc 의 id"
  value       = module.vpc.id
}

output "vpc_cidr" {
  description = "생성된 vpc 의 cidr 영역"
  value       = module.vpc.cidr_block
}

output "subnet_groups" {
  description = "생성된 vpc 의 subnet group 정보"
  
  value = {
    public  = module.subnet_group__public
    private = module.subnet_group__private
  }
}

// output "publci_subnet_group" {
//   value = module.subnet_group__public
// }

// output "private_subnet_group" {
//   value = module.subnet_group__private
// }

module "vpc" {
  # moudle source 와 버전을 명시한다.
  source  = "tedilabs/network/aws//modules/vpc"
  version = "0.24.0"

  # variable 을 통해 vpc 이름, cidr_block 과 같은 필수 인자를 설정한다.
  name       = var.vpc_name
  cidr_block = "10.0.0.0/16"

  internet_gateway_enabled = true

  # 
  dns_hostnames_enabled = true
  dns_support_enabled   = true

  tags = local.common_tags
}

# vpc 내 public subnet 생성
module "subnet_group__public" {
  source  = "tedilabs/network/aws//modules/subnet-group"
  version = "0.24.0"

  name                    = "${module.vpc.name}-public"
  vpc_id                  = module.vpc.id
  map_public_ip_on_launch = true

  subnets = {
    "${module.vpc.name}-public-001/az1" = {
      cidr_block           = "10.0.0.0/24"
      availability_zone_id = "apne2-az1"
    }
    "${module.vpc.name}-public-002/az2" = {
      cidr_block           = "10.0.1.0/24"
      availability_zone_id = "apne2-az2"
    }
  }

  tags = local.common_tags
}

# vpc 내 private subnet 생성
module "subnet_group__private" {
  source  = "tedilabs/network/aws//modules/subnet-group"
  version = "0.24.0"

  name                    = "${module.vpc.name}-private"
  vpc_id                  = module.vpc.id
  map_public_ip_on_launch = false

  subnets = {
    "${module.vpc.name}-private-001/az1" = {
      cidr_block           = "10.0.10.0/24"
      availability_zone_id = "apne2-az1"
    }
    "${module.vpc.name}-private-002/az2" = {
      cidr_block           = "10.0.11.0/24"
      availability_zone_id = "apne2-az2"
    }
  }

  tags = local.common_tags
}

# public subnet 에 대한 routing table 정의
module "route_table__public" {
  source  = "tedilabs/network/aws//modules/route-table"
  version = "0.24.0"

  name   = "${module.vpc.name}-public"
  vpc_id = module.vpc.id

  subnets = module.subnet_group__public.ids

  # subnet 내에서 발생하는 모든 트래픽을 igw 로 
  ipv4_routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = module.vpc.internet_gateway_id
    },
  ]

  tags = local.common_tags
}

# private subnet 에 대한 routing table 정의
# 운영 환경에서는 NAT Gateway 등을 설정한다.
module "route_table__private" {
  source  = "tedilabs/network/aws//modules/route-table"
  version = "0.24.0"

  name   = "${module.vpc.name}-private"
  vpc_id = module.vpc.id

  subnets = module.subnet_group__private.ids

  ipv4_routes = []

  tags = local.common_tags
}
