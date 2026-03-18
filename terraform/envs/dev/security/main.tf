module "ssm_role" {
  source               = "../../../modules/new_modules/assume_role"
  role_name            = var.role_name
  max_session_duration = var.max_session_duration
  trusted_arns         = var.trusted_arns
  policy_arns          = var.policy_arns
  prefix               = local.prefix
}