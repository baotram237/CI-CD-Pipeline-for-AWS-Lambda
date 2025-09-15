resource "aws_codebuild_project" "infra-tf-plan" {
  name         = "${var.name_prefix}-infra-tf-plan"
  description  = "Plan stage for terraform"
  service_role = var.roles_codebuild

  artifacts { type = "CODEPIPELINE" }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "ARTIFACTS_BUCKET"
      value = var.artifact_bucket
    }

    environment_variable {
      name  = "env_file"
      value = var.env_file
    }

    environment_variable {
      name  = "backend_config"
      value = var.backend_config
    }

    environment_variable {
      name  = "TF_EXEC_ROLE"
      value = var.tf_exec_role
    }

    environment_variable {
      name  = "ARTIFACTS_FOLDER"
      value = var.artifacts_folder
    }

  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/buildspec/tf-plan-buildspec.yml")
  }
}


resource "aws_codebuild_project" "infra-tf-apply" {
  name         = "${var.name_prefix}-infra-tf-apply"
  description  = "Apply stage for terraform"
  service_role = var.roles_codebuild

  artifacts { type = "CODEPIPELINE" }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "ARTIFACTS_BUCKET"
      value = var.artifact_bucket
    }
    environment_variable {
      name  = "env_file"
      value = var.env_file
    }

    environment_variable {
      name  = "backend_config"
      value = var.backend_config
    }

    environment_variable {
      name  = "TF_EXEC_ROLE"
      value = var.tf_exec_role
    }

    environment_variable {
      name  = "ARTIFACTS_FOLDER"
      value = var.artifacts_folder
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/buildspec/tf-apply-buildspec.yml")
  }
}


resource "aws_codebuild_project" "lambda" {
  name         = "${var.name_prefix}-lambda"
  description  = "Build project for Lambda packaging"
  service_role = var.roles_codebuild

  artifacts { type = "CODEPIPELINE" }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = false

    environment_variable {
      name  = "ARTIFACTS_BUCKET"
      value = var.artifact_bucket
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/buildspec/lambda-buildspec.yml")
  }
}
