terraform {
  backend "s3" {}
}

module "codecommit" {
  source      = "./modules/codecommit"
  name_prefix = var.name_prefix
}

module "s3" {
  source      = "./modules/s3"
  name_prefix = var.name_prefix
}

module "lambda" {
  source            = "./modules/lambda"
  function_name     = var.lambda_name
  artifact_bucket   = module.s3.artifacts_bucket_name
  s3_key            = "lambda/${var.lambda_name}.zip"
  s3_object_version = var.s3_object_version
  handler           = "lambda_function.lambda_handler"
  runtime           = "python3.9"
}

module "cicd-iam" {
  source               = "./modules/iam"
  lambda_name          = var.lambda_name
  artifact_bucket      = var.artifact_bucket
  tfstate_bucket       = var.tfstate_bucket
  terraform_lock_table = var.terraform_lock_table
  account_id           = var.account_id
  name_prefix          = var.name_prefix
  infras_repo_name     = module.codecommit.infras_repo_name
  app_repo_name        = module.codecommit.app_repo_name
  infra_pipeline_arn   = module.codepipeline.infra_pipeline_arn

}

module "codebuild" {
  source          = "./modules/codebuild"
  name_prefix     = var.name_prefix
  roles_codebuild = module.cicd-iam.cicd_codebuild_role_arn
  artifact_bucket = var.artifact_bucket
  env_file        = var.env_file
  backend_config  = var.backend_config
  tf_exec_role    = module.cicd-iam.cicd_terraform_exec_role_arn
  artifacts_folder = var.artifacts_folder
}

module "codepipeline" {
  source                 = "./modules/codepipeline"
  name_prefix            = var.name_prefix
  role_codepipeline_arn  = module.cicd-iam.cicd_codepipeline_role_arn
  artifact_bucket        = var.artifact_bucket
  app_repo_name          = var.app_repo_name
  app_repo_branch        = var.app_repo_branch
  codebuild_project_name = module.codebuild.lambda_project_name
  infras_repo_name      = var.infras_repo_name
  infras_repo_branch    = var.infras_repo_branch
  codebuild_plan_infra_project = module.codebuild.plan_infra_project_name
  codebuild_apply_infra_project = module.codebuild.apply_infra_project_name
  enable_manual_approval = false
}

module "eventbridge" {
  source                       = "./modules/eventbridge"
  name_prefix                  = var.name_prefix
  evb_to_codepipeline_role_arn = module.cicd-iam.cicd_evb_to_codepipeline_role_arn
  lambda_pipeline_name         = module.codepipeline.lambda_pipeline_name
  infra_pipeline_arn           = module.codepipeline.infra_pipeline_arn
}
