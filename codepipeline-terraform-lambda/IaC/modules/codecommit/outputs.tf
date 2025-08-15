output infras-repo-url {
  value       = aws_codecommit_repository.infras_repo.clone_url_http
}

output app-repo-url {
  value       = aws_codecommit_repository.app_repo.clone_url_http
}
