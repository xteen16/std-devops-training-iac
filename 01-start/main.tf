provider "local" {
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
