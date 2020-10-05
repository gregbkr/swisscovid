provider "aws" {
  version = "~> 2.62"
  region  = "eu-west-1"
  profile = "gregbkr"
}

terraform {
  required_version = "~> 0.12.0"
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "gregbkr"
    workspaces {
      name = "swisscovid-prod"
    }
  }
}

variable "dns_domain" {
  default = "satoshi.tech"
}
variable "dns_record" {
  default = "swisscovid"
}
variable "cert_arn" {
  default = "arn:aws:acm:us-east-1:282835178041:certificate/e34fadff-b0d8-47d4-978f-58bd41b6194a"
}
variable "iam_user" {
  default = "swisscovid.com-write-to-s3"
}

# CALL MODULES
module "my_s3" {
  source       = "../modules/s3"
  bucket       = "${var.dns_record}.${var.dns_domain}"
  iam_user_arn = "${module.my_iam.iam_user_arn}"
}

module my_iam {
  source     = "../modules/iam"
  iam_user   = "${var.dns_record}.${var.dns_domain}-write-to-s3"
  bucket_arn = "${module.my_s3.bucket_arn}"
}

module my_cloudfront {
  source        = "../modules/cloudfront"
  dns_domain    = "${var.dns_record}.${var.dns_domain}"
  bucket_domain = "${module.my_s3.bucket_url}"
  cert_arn      = "${var.cert_arn}"
}

module my_route53 {
  source         = "../modules/route53"
  dns_domain     = "${var.dns_domain}"
  dns_record     = "${var.dns_record}"
  bucket_url     = "${module.my_cloudfront.domain_name}"
  bucket_zone_id = "${module.my_cloudfront.hosted_zone_id}"
}

# OUPUTS
output "my_bucket_arn" {
  value = "${module.my_s3.bucket_arn}"
}
output "my_bucket_name" {
  value = "${module.my_s3.bucket_name}"
}
output "my_bucket_url" {
  value = "${module.my_s3.bucket_url}"
}
output "my_bucket_hosted_zone_id" {
  value = "${module.my_s3.bucket_hosted_zone_id}"
}
output "my_iam_user_name" {
  value = "${module.my_iam.iam_user_name}"
}
output "my_iam_id" {
  value = "${module.my_iam.iam_id}"
}
output "my_iam_secret" {
  value = "${module.my_iam.iam_secret}"
}
output "my_cloudfront_url" {
  value = "${module.my_cloudfront.domain_name}"
}