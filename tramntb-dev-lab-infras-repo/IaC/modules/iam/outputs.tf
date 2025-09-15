output "cicd_codebuild_role_arn" {
  description = "ARN of the IAM Role used by CodeBuild"
  value       = aws_iam_role.roles_codebuild.arn
}

output "cicd_codepipeline_role_arn" {
  description = "ARN of the IAM Role used by codepipeline"
  value       = aws_iam_role.roles_codepipeline.arn
}

output "cicd_terraform_exec_role_arn" {
  description = "ARN of the IAM Role to be assumed by CodeBuild for Terraform execution"
  value       = aws_iam_role.roles_terraform_exec.arn
}

output "cicd_terraform_exec_role_name" {
  description = "Name of the IAM Role to be assumed by CodeBuild for Terraform execution"
  value       = aws_iam_role.roles_terraform_exec.name
}

output "cicd_evb_to_codepipeline_role_arn" {
  description = "ARN of the IAM Role that allows EventBridge to trigger CodePipeline"
  value       = aws_iam_role.evb_to_codepipeline_role.arn
}