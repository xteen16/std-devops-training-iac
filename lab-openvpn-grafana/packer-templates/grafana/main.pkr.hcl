build {
  name = "aws"

  sources = [
    "amazon-ebs.ubuntu",
  ]

  provisioner "shell" {
    # cloud-init status --wait
    # 유저 데이터로 정의되어 있는 명령들이 다 실행될 때까지 기다린다.
    inline = [
      "mkdir -m 755 -p /opt/ansible",
      "chown -R ubuntu:ubuntu /opt/ansible",
      "cloud-init status --wait",
    ]
    execute_command = "sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
  }

  provisioner "ansible" {
    playbook_file = "${path.root}/ansible/initialize.yaml"
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
    ]
    ansible_ssh_extra_args = [
      "-o ForwardAgent=yes",
    ]
    user="ubuntu"
  }

  provisioner "ansible-local" {
    playbook_file = "${path.root}/ansible/playbook.yaml"
    staging_directory = "/opt/ansible/"
    clean_staging_directory = false
  }

  post-processor "manifest" {
    # packer manifest 파일을 output 경로에 생성
    output     = "dist/packer-manifest.json"
    strip_path = true
  }
}
