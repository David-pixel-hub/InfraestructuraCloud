output "alb_dns_name" {
  description = "DNS publica del balanceador de carga"
  # value = module.umg_alb_asg.alb_dns_name
  value = "http://${module.umg_alb_asg.alb_dns_name}"
}