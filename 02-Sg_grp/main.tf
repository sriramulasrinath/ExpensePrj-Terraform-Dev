module "db" {
  source = "../../Terraform-SG-module"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for DB MYSQL Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags 
  sg_name = "Db"
}

module "backend" {
  source = "../../Terraform-SG-module"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for backend Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags 
  sg_name = "backend"
}
module "frontend" {
  source = "../../Terraform-SG-module"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG frontend Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags 
  sg_name = "frontend"
}
### Db is accepting connections from backend
resource "aws_security_group_rule" "db-backend" {
  type              = "ingress"
  from_port         =3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend.sg_id #where you are getting traffic from
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "backend_frontend" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id #where you are getting traffic from
  security_group_id = module.backend.sg_id
}
resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks =  ["0.0.0.0/0"]#where you are getting traffic from
  security_group_id = module.frontend.sg_id
}