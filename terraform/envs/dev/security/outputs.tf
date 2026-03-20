output "sg_id" {
  value = {
    web_sg      = module.web_sg.sg_id
    app_sg      = module.app_sg.sg_id
    web_alb_sg  = module.web_alb_sg.sg_id
    app_alb_sg  = module.app_alb_sg.sg_id
    database_sg = module.database_sg.sg_id
  }
}

output "ssm_role_profile" {
  value = module.ssm_role.instance_role["name"]
}