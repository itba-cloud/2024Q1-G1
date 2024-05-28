output "alb_arn" {
  description = "The ARN of the Load Balancer."
  value       = aws_lb.lendaread_alb.arn
}

output "target_group_arn" {
  description = "The ARN of the target group."
  value       = aws_lb_target_group.lendaread_tg.arn
}

output "alb_dns_name" {
  value = aws_lb.lendaread_alb.dns_name
}

output "tg_arn" {
  value = aws_lb_target_group.lendaread_tg.arn
}
