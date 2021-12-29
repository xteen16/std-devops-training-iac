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
    # 이미 source 로 정의한 값에 대해서는 재정의가 불가능하다.
    name = "terraform"
  }

  source "null.two" {
    name = "vault"
  }
}
