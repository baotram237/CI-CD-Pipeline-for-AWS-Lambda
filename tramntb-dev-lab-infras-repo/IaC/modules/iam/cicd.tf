locals {
  iam_role_cicd                  = "cicd"
  iam_policies_cicd_codebuild    = ["cicd-codebuild"]
  iam_role_cicd_codebuild        = "cicd-codebuild"
  iam_policies_cicd_codepipeline = ["cicd-codepipeline"]
  iam_role_cicd_codepipeline     = "cicd-codepipeline"
}

# CICD Role

# ----------------------------------------
# CICD Role for CodeBuild
# ----------------------------------------
data "template_file" "policies_codebuild_src" {
  for_each = { for e in local.iam_policies_cicd_codebuild : e => e }
  template = file("${path.module}/policies/${each.value}.json")
  vars = {
    lambda_name          = var.lambda_name
    artifact_bucket      = var.artifact_bucket
    tfstate_bucket       = var.tfstate_bucket
    terraform_lock_table = var.terraform_lock_table
    account_id           = var.account_id
  }
}

resource "aws_iam_policy" "policies_codebuild" {
  for_each = data.template_file.policies_codebuild_src
  name     = format("service-policy-%s", each.key)
  policy   = each.value.rendered
}

resource "aws_iam_role" "roles_codebuild" {
  name = format("service-role-%s-codebuild", local.iam_role_cicd)
  # managed_policy_arns = [for e in aws_iam_policy.policies_codebuild : e.arn]
  assume_role_policy = file("${path.module}/roles/${local.iam_role_cicd_codebuild}.json")

  depends_on = [aws_iam_policy.policies_codebuild]
}

# Attach Custom Policy for CodeBuild
resource "aws_iam_role_policy_attachment" "policies_codebuild_attachments" {
  for_each = { for idx, policy in aws_iam_policy.policies_codebuild : idx => policy }

  role       = aws_iam_role.roles_codebuild.name
  policy_arn = each.value.arn
}

# Attach AWS Managed Policy for CodeBuild
resource "aws_iam_role_policy_attachment" "managed_policies_codebuild_attachments" {
  role       = aws_iam_role.roles_codebuild.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}
# ----------------------------------------
# CICD Role for CodePipeline
# ----------------------------------------
data "template_file" "policies_codepipeline_src" {
  for_each = { for e in local.iam_policies_cicd_codepipeline : e => e }
  template = file("${path.module}/policies/${each.value}.json")
  vars = {
    artifact_bucket = var.artifact_bucket
    account_id      = var.account_id
    name_prefix    = var.name_prefix
  }
}

resource "aws_iam_policy" "policies_codepipeline" {
  for_each = data.template_file.policies_codepipeline_src
  name     = format("service-policy-%s", each.key)
  policy   = each.value.rendered
}

resource "aws_iam_role" "roles_codepipeline" {
  name = format("service-role-%s-codepipeline", local.iam_role_cicd)
  #managed_policy_arns = [for e in aws_iam_policy.policies_codepipeline : e.arn]
  assume_role_policy = file("${path.module}/roles/${local.iam_role_cicd_codepipeline}.json")

  depends_on = [aws_iam_policy.policies_codepipeline]
}

resource "aws_iam_role_policy_attachment" "policies_codepipeline_attachments" {
  for_each = { for idx, policy in aws_iam_policy.policies_codepipeline : idx => policy }

  role       = aws_iam_role.roles_codepipeline.name
  policy_arn = each.value.arn
}

# ----------------------------------------
# CICD Role for Terraform Execution
# ----------------------------------------
data "template_file" "policies_terraform_exec_src" {
  template = file("${path.module}/policies/cicd-terraform-exec.json")
  vars = {
    tfstate_bucket = var.tfstate_bucket
    terraform_lock_table = var.terraform_lock_table
    infras_repo_name = var.infras_repo_name
    app_repo_name   = var.app_repo_name
    account_id      = var.account_id  
    artifact_bucket = var.artifact_bucket}
}

resource "aws_iam_policy" "policies_terraform_exec" {
  name     = "service-policy-cicd-terraform-exec"
  policy   = data.template_file.policies_terraform_exec_src.rendered
}

data "aws_iam_policy_document" "terraform_exec_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.roles_codebuild.arn]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "roles_terraform_exec" {
  name = format("service-role-%s-terraform-exec", local.iam_role_cicd)
  assume_role_policy = data.aws_iam_policy_document.terraform_exec_assume.json

  depends_on = [aws_iam_policy.policies_terraform_exec]
} 

resource "aws_iam_role_policy_attachment" "policies_terraform_exec_attachments" {
  role       = aws_iam_role.roles_terraform_exec.name
  policy_arn = aws_iam_policy.policies_terraform_exec.arn
}

