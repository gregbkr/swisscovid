variable "bucket" {}
variable "iam_user_arn" {}

# BUCKET TO HOST THE CODE
resource "aws_s3_bucket" "b" {
  bucket = var.bucket
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"

    routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }
}

resource "aws_s3_bucket_policy" "b" {
  bucket = aws_s3_bucket.b.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "${var.bucket}",
  "Statement": [
    {
      "Sid": "AllowPublicReadAccess",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "${aws_s3_bucket.b.arn}/*"
    },
    {
      "Sid": "ListBucket",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.iam_user_arn}"
      },
      "Action": [
        "s3:GetBucketLocation",
        "s3:ListBucket"
      ],
      "Resource": "${aws_s3_bucket.b.arn}"
    },
    {
      "Sid": "Write2Bucket",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.iam_user_arn}"
      },
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:PutObjectAcl"
      ],
      "Resource": "${aws_s3_bucket.b.arn}/*"
    }
  ]
}
POLICY
}


output "bucket_arn" {
  value = aws_s3_bucket.b.arn
}
output "bucket_name" {
  value = aws_s3_bucket.b.bucket
}

output "bucket_url" {
  value = aws_s3_bucket.b.website_endpoint
}

output "bucket_hosted_zone_id" {
  value = aws_s3_bucket.b.hosted_zone_id
}

output "bucket_domain_name" {
  value = aws_s3_bucket.b.bucket_domain_name
}




