output "sg_id" {
  value = {
    web_sg = module.web_sg.sg_id
    app_sg = module.app_sg.sg_id
  }
}

output "role_name" {
  value = {
    ssm = module.ssm_role.role_name
  }
}