terraform {
  backend "s3" {}
}

module codecommit {
  source = "./modules/codecommit"
  name_prefix = var.name_prefix
}


