variable "name_prefix" { type = string }
variable "role_codepipeline_arn" { type = string }
variable "artifact_bucket" { type = string }
variable "codebuild_plan_infra_project"{ type = string }
variable "codebuild_apply_infra_project"{ type = string }
# variable "codebuild_lambda_project"{ type = string }
variable "infras_repo_name"              { type = string }
variable "infras_repo_branch"            { type = string }
variable "app_repo_name" { type = string }
variable "app_repo_branch" { type = string }
variable "enable_manual_approval" {
  description = "Enable manual approval stage in pipeline"
  type        = bool
  default     = true
}
variable "codebuild_project_name" { type = string }