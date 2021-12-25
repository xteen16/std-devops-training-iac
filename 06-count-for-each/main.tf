provider "aws" {
  region = "ap-northeast-2"
}

/*
 * No count / for_each
 */
resource "aws_iam_user" "user_1" {
  name = "user-1"
}

resource "aws_iam_user" "user_2" {
  name = "user-2"
}

resource "aws_iam_user" "user_3" {
  name = "user-3"
}

output "user_arns" {
  value = [
    aws_iam_user.user_1.arn,
    aws_iam_user.user_2.arn,
    aws_iam_user.user_3.arn
  ]
}

/*
 * count
 */
resource "aws_iam_user" "count" {
  count = 10

  name = "count-user-${count.index}"
}

output "count_user_arns" {
  value = aws_iam_user.count.*.arn
}

/*
 * for_each
 */
resource "aws_iam_user" "for_each_set" {
  # toset 을 통해 list 를 set 으로 형변환
  # for_each 를 사용하면 each.key, each.value 를 사용할 수 있음
  # set 형은 key, value 다 동일한 값임
  for_each = toset([
    "for-each-set-user-1",
    "for-each-set-user-2",
    "for-each-set-user-3"
  ])

  name = each.key
}

output "for_each_set_user_arns" {
  # 위에서 작성한 for_each_set 의 결과는 다음과 같음
  # {for_each_ser-user-1 = {**object**}, ...}
  # 따라서 values 함수를 통해 value 만 가져와서 arn 을 획득해야함
  # values 함수를 타면 object list 가 반환됨
  value = values(aws_iam_user.for_each_set).*.arn
}

resource "aws_iam_user" "for_each_map" {
  # map 형을 통해 iam user 생성
  # map 의 key 는 항상 string
  for_each = {
    alice = {
      level   = "low"
      manager = "padella"
    }
    bob = {
      level   = "mid"
      manager = "padella"
    }
    john = {
      level   = "high"
      manager = "steve"
    }
  }

  name = each.key

  tags = each.value
}

output "for_each_map_user_arns" {
  value = values(aws_iam_user.for_each_map).*.arn
}
