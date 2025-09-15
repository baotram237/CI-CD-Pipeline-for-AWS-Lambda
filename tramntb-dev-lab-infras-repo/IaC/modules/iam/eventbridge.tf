#############################
# IAM Role for EventBridge → CodePipeline
#############################
resource "aws_iam_role" "evb_to_codepipeline_role" {
  name = "${var.name_prefix}-evb-to-codepipeline"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "events.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "evb_to_codepipeline_policy" {
  name        = "${var.name_prefix}-evb-to-codepipeline-policy"
  description = "Allow EventBridge to trigger CodePipeline execution"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "codepipeline:StartPipelineExecution",
        Resource = var.infra_pipeline_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "evb_to_codepipeline_attach" {
  role       = aws_iam_role.evb_to_codepipeline_role.name
  policy_arn = aws_iam_policy.evb_to_codepipeline_policy.arn
}
