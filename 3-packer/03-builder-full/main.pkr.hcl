build {
  name = "fastcampus-packer"

  source "amazon-ebs.ubuntu" {
    name     = "vault"
    ami_name = "fastcampus-packer-vault"
  }

  source "amazon-ebs.ubuntu" {
    name     = "consul"
    ami_name = "fastcampus-packer-consul"
  }

  # provisioner 와 post-processor 의 순서는 중요하다
  # 차례로 실행됨..
  provisioner "shell" {
    inline = [
      "echo Next World!"
    ]
  }

  post-processor "shell-local" {
    inline = [
      "echo Hello World!"
    ]
  }

  port-processor "shell-local" {
    inline = [
      "echo Next World!"
    ]
  }
}
