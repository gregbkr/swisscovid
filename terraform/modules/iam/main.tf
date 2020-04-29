variable "iam_user" {}
variable "bucket_arn" {}

# IAM USER FOR GITLAB
resource "aws_iam_user" "s3" {
  name = var.iam_user
  path = "/system/"

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_access_key" "s3" {
  user = aws_iam_user.s3.name
}

resource "aws_iam_user_policy" "s3_rw" {
  name = var.iam_user
  user = aws_iam_user.s3.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
     "Resource": [
        "${var.bucket_arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:PutObjectAcl"
      ],
      "Resource": [
         "${var.bucket_arn}/*"
      ]
    }
  ]
}
EOF
}

output "iam_user_arn" {
  value = aws_iam_user.s3.arn
}
output "iam_user_name" {
  value = aws_iam_user.s3.name
}

output "iam_id" {
  value = aws_iam_access_key.s3.id
}
output "iam_secret" {
  value = aws_iam_access_key.s3.secret
}