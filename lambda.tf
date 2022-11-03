// Create Lambda Function
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function
resource "aws_lambda_function" "s3_lambda" {
  filename         = "lambda_function_s3.zip"
  function_name    = "lambda_get_s3_resource"
  role             = aws_iam_role.admin_role.arn
  handler          = "lambda_function_s3/index.handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_s3.zip"))}"
  source_code_hash = filebase64sha256("lambda_function_s3.zip")
  runtime          = "nodejs16.x"
}

// Create Lambda Function
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function
resource "aws_lambda_function" "dynamodb_lambda" {
  filename         = "lambda_function_dynamodb.zip"
  function_name    = "lambda_get_dynamodb_resource"
  role             = aws_iam_role.admin_role.arn
  handler          = "lambda_function_dynamodb/index.handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_dynamodb.zip"))}"
  source_code_hash = filebase64sha256("lambda_function_dynamodb.zip")
  runtime          = "nodejs16.x"
}

// Create Lambda Permission - Trigger
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission
resource "aws_lambda_permission" "s3_trigger" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.spike_vue_web.id}"
}

// Create Lambda Permission - Trigger
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission
resource "aws_lambda_permission" "api_gateway_trigger" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  //source_arn    = "arn:aws:execute-api:::${aws_api_gateway_rest_api.get_s3_api_gateway.id}"
  //source_arn    = "${aws_api_gateway_rest_api.get_s3_api_gateway.execution_arn}/*//*"
}

// Create Lambda Event - Trigger
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping
resource "aws_lambda_event_source_mapping" "aws_lambda_event_source_dynamodb" {
  event_source_arn  = "arn:aws:dynamodb:us-east-1:053902646351:table/Compound/stream/2022-10-24T15:13:10.950"
  function_name     = aws_lambda_function.dynamodb_lambda.arn
  starting_position = "LATEST"
}