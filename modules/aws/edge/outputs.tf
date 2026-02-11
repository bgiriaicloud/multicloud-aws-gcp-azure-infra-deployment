output "edge_outputs" {
  value = {
    cloudfront_domain = aws_cloudfront_distribution.main.domain_name
    route53_zone_id   = aws_route53_zone.main.zone_id
  }
}
