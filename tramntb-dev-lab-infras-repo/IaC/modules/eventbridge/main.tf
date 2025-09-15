# EventBridge Rule

resource "aws_cloudwatch_event_rule" "lambda_pipeline_success" {
  name        = "${var.name_prefix}-lambda-pipeline-success"
  description = "Trigger Infra pipeline when Lambda pipeline succeeds"
  event_pattern = jsonencode({
    "source": ["aws.codepipeline"],
    "detail-type": ["CodePipeline Pipeline Execution State Change"],
    "detail": {
      "state": ["SUCCEEDED"],
      "pipeline": [var.lambda_pipeline_name]
    }
  })
}

# EventBridge Target

resource "aws_cloudwatch_event_target" "trigger_infra_pipeline" {
  rule      = aws_cloudwatch_event_rule.lambda_pipeline_success.name
  target_id = "StartInfraPipeline"
  arn       = var.infra_pipeline_arn
  role_arn  = var.evb_to_codepipeline_role_arn
}