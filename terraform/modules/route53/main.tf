variable "dns_domain" {}
variable "dns_record" {}
variable "bucket_url" {}
variable "bucket_zone_id" {}

data "aws_route53_zone" "main" {
  name = var.dns_domain
}

output "zone_id" {
  value = data.aws_route53_zone.main.zone_id
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.dns_record
  type    = "A"

  alias {
    name                   = var.bucket_url
    zone_id                = var.bucket_zone_id
    evaluate_target_health = false
  }
}