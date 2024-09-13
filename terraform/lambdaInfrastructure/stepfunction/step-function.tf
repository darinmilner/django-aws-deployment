# Step Functions State Machine
resource "aws_sfn_state_machine" "step-frunction-processor" {
  name     = "s3-bucket-step-function"
  role_arn = aws_iam_role.step-functions-role.arn

  definition = <<EOF
{
    "Comment": "execute lambdas",
    "StartAt": "CheckAge",
    "States": {
    "CheckAge": {
        "Type": "Task",
        "Resource": "${aws_lambda_function.check-age-lambda.arn}",
        "Next": "Success"
    },
    "Success": {
        "Type": "Choice",
        "Choices": [
        {
            "Variable": "$.Payload.success",
            "BooleanEquals": true,
            "Next": "CreateBucket"
        }
        ],
        "Default": "CreateBucket"
    },
    "CreateBucket": {
        "Type": "Task",
        "Resource": "${aws_lambda_function.create-bucket-lambda.arn}",
        "Next" : "Success"
    },
    "Success": {
        "Type": "Choice",
        "Choices": [
        {
            "Variable": "$.Payload.success",
            "BooleanEquals": true,
            "Next": "Upload"
        }
        ],
        "Default": "Upload"
    },
    "Upload": {
        "Type": "Task",
        "Resource": "${aws_lambda_function.upload-lambda.arn}",
        "End": true
    }
    }
}
EOF
}