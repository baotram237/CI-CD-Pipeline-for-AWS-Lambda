
resource "aws_codepipeline" "this" {
  name     = "${var.name_prefix}-infras-pipeline"
  role_arn = var.role_codepipeline_arn

  artifact_store {
    type     = "S3"
    location = var.artifact_bucket
  }

  stage {
    name = "Source"
    action {
      name             = "CodeCommitSource"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = var.infras_repo_name
        BranchName     = var.infras_repo_branch
        OutputArtifactFormat = "CODE_ZIP"
        PollForSourceChanges = true
      }
    }
  }

  stage {
    name = "TerraformPlan"
      action {
        name            = "TerraformPlan"
        category        = "Build"
        owner           = "AWS"
        provider        = "CodeBuild"
        version         = "1"
        input_artifacts = ["source_output"]
        output_artifacts = ["plan_output"]

        configuration = { ProjectName = var.codebuild_plan_infra_project }
      }
    }

  dynamic "stage" {
    for_each = var.enable_manual_approval ? [1] : []
      content {
        name = "ManualApproval"
        action {
          name            = "ManualApproval"
          category        = "Approval"
          provider        = "Manual"
          version         = "1"
          owner           = "AWS"
          input_artifacts = []
        }
      }
    }


  stage {
    name = "TerraformApply"
      action {
        name            = "TerraformApply"
        category        = "Build"
        owner           = "AWS"
        provider        = "CodeBuild"
        version         = "1"
        input_artifacts = ["source_output"]

        configuration = { ProjectName = var.codebuild_apply_infra_project }
      }
    }
}


resource "aws_codepipeline" "lambda" {
  name     = "${var.name_prefix}-lambda-pipeline"
  role_arn = var.role_codepipeline_arn

  artifact_store {
    type     = "S3"
    location = var.artifact_bucket
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = var.app_repo_name
        BranchName     = var.app_repo_branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "LambdaBuild"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = var.codebuild_project_name
      }
    }
  }
}