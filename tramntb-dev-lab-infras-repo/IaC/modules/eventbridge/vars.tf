variable "name_prefix" {
  type        = string
  default     = ""
  description = "description"
}

variable "evb_to_codepipeline_role_arn" {
  type        = string
  description = "ARN of the IAM Role that allows EventBridge to trigger CodePipeline"
}

variable "lambda_pipeline_name" {
  type        = string
  description = "Name of the Lambda CodePipeline"
}

variable "infra_pipeline_arn" {
  type        = string
  description = "ARN of the Infrastructure CodePipeline"
}
