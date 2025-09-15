# source
resource "aws_codecommit_repository" "infras_repo" {
  repository_name = "${var.name_prefix}-infras-repo"
  default_branch  = "master"
}

resource "aws_codecommit_repository" "app_repo" {
  repository_name = "${var.name_prefix}-app-repo"
  default_branch  = "prod"
}
