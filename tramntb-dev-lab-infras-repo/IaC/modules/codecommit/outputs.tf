output "infras_repo_url" {
  value = aws_codecommit_repository.infras_repo.clone_url_http
}

output "app_repo_url" {
  value = aws_codecommit_repository.app_repo.clone_url_http
}

output "infras_repo_name" {
  value = aws_codecommit_repository.infras_repo.repository_name
}

output "app_repo_name" {
  value = aws_codecommit_repository.app_repo.repository_name
}