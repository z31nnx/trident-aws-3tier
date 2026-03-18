output "vpc_id" {
  value = {
    main_vpc = module.main_vpc.vpc_id
  }
}