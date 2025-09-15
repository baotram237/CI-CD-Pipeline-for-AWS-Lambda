variable "artifact_bucket" {
  description = "Artifact bucket name where Lambda zips are stored"
  type        = string
}

variable "tfstate_bucket" {
  type = string
}

variable "terraform_lock_table" {
  type = string
}

variable "account_id" {
  type    = string
}

variable "lambda_name" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "infras_repo_name" {
  type = string
}

variable "app_repo_name" {
  type = string
}

# variable "terraform_exec_role_name" {
#   description = "Name of the IAM Role to be assumed by CodeBuild for Terraform execution"
#   type        = string
# }

# variable "codebuild_role_name" {
#   type        = string
#   description = "Name of the IAM Role to be assumed by CodeBuild for application build and deployment"
# }

variable "infra_pipeline_arn" {
  type = string
}