output "infra_pipeline_arn" {
    value       = aws_codepipeline.this.arn
    description = "ARN of the Infrastructure CodePipeline"
}

output "lambda_pipeline_name" {
  value       = aws_codepipeline.lambda.name
}
