output "plan_infra_project_name"  { value = aws_codebuild_project.infra-tf-plan.name }
output "apply_infra_project_name"  { value = aws_codebuild_project.infra-tf-apply.name }
output "lambda_project_name" { value = aws_codebuild_project.lambda.name }