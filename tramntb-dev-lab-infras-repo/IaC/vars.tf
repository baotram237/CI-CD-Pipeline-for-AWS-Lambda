variable "aws_region" {
  type        = string
  default     = "ap-southeast-1"
  description = "Region"
}

variable "name_prefix" {
  type = string
}

variable "lambda_name" {
  type        = string
  description = "Name of lambda function"
}

variable "s3_object_version" {
  type        = string
  description = "S3 object version for the lambda zip file"
}

variable "artifact_bucket" {
  description = "Artifact bucket name where Lambda zips are stored"
  type        = string
}

variable "artifacts_folder" {
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


variable "app_repo_name" { type = string }
variable "app_repo_branch" { type = string }
variable "infras_repo_name" { type = string }
variable "infras_repo_branch" { type = string }

variable "env_file" {
  type        = string
  description = "Path to the environment variable file for Terraform"
}

variable "backend_config" {
  type        = string
  description = "Path to the backend configuration file for Terraform"
}
