/*
 * Without Name
 */
# build 블록은 프로세스를 정의한다.
build {
  sources = [
    "source.null.one",
    "source.null.two",
  ]
}

/*
 * With Name
 */
build {
  name = "fastcampus-packer"

  sources = [
    "source.null.one",
    "source.null.two",
  ]
}

/*
 * Fill-in
 */
build {
  name = "fastcampus-packer-fill-in"

  source "null.one" {
    name = "terraform"
  }

  source "null.two" {
    name = "vault"
  }
}
