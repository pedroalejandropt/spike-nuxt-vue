// Create API Gateway
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api
resource "aws_api_gateway_rest_api" "get_s3_api_gateway" {
    name = "S3APIGateway"

    endpoint_configuration {
        types = ["REGIONAL"]
    }
}

// Create Resource
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource
resource "aws_api_gateway_resource" "get_s3_api_gateway_resource" {
    rest_api_id = aws_api_gateway_rest_api.get_s3_api_gateway.id
    parent_id   = aws_api_gateway_rest_api.get_s3_api_gateway.root_resource_id
    path_part   = "vue-spike"
}

// Create Method
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method
resource "aws_api_gateway_method" "get_s3_api_gateway_method" {
    rest_api_id   = aws_api_gateway_rest_api.get_s3_api_gateway.id
    resource_id   = aws_api_gateway_resource.get_s3_api_gateway_resource.id
    http_method   = "ANY"
    authorization = "NONE"
    request_parameters = {
      "method.request.header.Authorization" = false
    }
}

// Create Integration
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration
resource "aws_api_gateway_integration" "get_s3_api_gateway_integration" {
    rest_api_id             = aws_api_gateway_rest_api.get_s3_api_gateway.id
    resource_id             = aws_api_gateway_resource.get_s3_api_gateway_resource.id
    http_method             = aws_api_gateway_method.get_s3_api_gateway_method.http_method
    integration_http_method = "ANY"
    type                    = "AWS"
    uri                     = aws_lambda_function.s3_lambda.invoke_arn
    content_handling = "CONVERT_TO_TEXT"

    depends_on              = [
      aws_lambda_function.s3_lambda
    ]
}

// Create Method Response
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_response
resource "aws_api_gateway_method_response" "response_200" {
    rest_api_id = aws_api_gateway_rest_api.get_s3_api_gateway.id
    resource_id = aws_api_gateway_resource.get_s3_api_gateway_resource.id
    http_method = aws_api_gateway_method.get_s3_api_gateway_method.http_method
    status_code = "200"
    response_models = {
      "application/json" = "Empty"
    }

    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Origin" = true
    }

    depends_on = [aws_api_gateway_method.get_s3_api_gateway_method]
}

// Create Integration Response
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration_response
resource "aws_api_gateway_integration_response" "get_s3_api_gateway_integration_response" {
    rest_api_id         = aws_api_gateway_rest_api.get_s3_api_gateway.id
    resource_id         = aws_api_gateway_resource.get_s3_api_gateway_resource.id
    http_method         = aws_api_gateway_method.get_s3_api_gateway_method.http_method
    status_code         = aws_api_gateway_method_response.response_200.status_code

    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
        "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
        "method.response.header.Access-Control-Allow-Origin" = "'*'"
    }

    depends_on          = [
      aws_api_gateway_method_response.response_200,
      aws_api_gateway_integration.get_s3_api_gateway_integration
    ]
}

// OPTIONS
/* resource "aws_api_gateway_method" "options_method" {
    rest_api_id   = "${aws_api_gateway_rest_api.get_s3_api_gateway.id}"
    resource_id   = "${aws_api_gateway_resource.get_s3_api_gateway_resource.id}"
    http_method   = "OPTIONS"
    authorization = "NONE"
}
resource "aws_api_gateway_method_response" "options_200" {
    rest_api_id   = "${aws_api_gateway_rest_api.get_s3_api_gateway.id}"
    resource_id   = "${aws_api_gateway_resource.get_s3_api_gateway_resource.id}"
    http_method   = "${aws_api_gateway_method.options_method.http_method}"
    status_code   = "200"
    response_models = {
        "application/json" = "Empty"
    }
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Origin" = true
    }
    depends_on = [aws_api_gateway_method.options_method]
}
resource "aws_api_gateway_integration" "options_integration" {
    rest_api_id   = "${aws_api_gateway_rest_api.get_s3_api_gateway.id}"
    resource_id   = "${aws_api_gateway_resource.get_s3_api_gateway_resource.id}"
    http_method   = "${aws_api_gateway_method.options_method.http_method}"
    type          = "MOCK"
    content_handling = "CONVERT_TO_TEXT"
    depends_on = [aws_api_gateway_method.options_method]
    passthrough_behavior = "WHEN_NO_MATCH"
    request_templates = {
      "application/json" : "{\"statusCode\": 200}"
    }
}
resource "aws_api_gateway_integration_response" "options_integration_response" {
    rest_api_id   = "${aws_api_gateway_rest_api.get_s3_api_gateway.id}"
    resource_id   = "${aws_api_gateway_resource.get_s3_api_gateway_resource.id}"
    http_method   = "${aws_api_gateway_method.options_method.http_method}"
    status_code   = "${aws_api_gateway_method_response.options_200.status_code}"
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
        "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
        "method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = [aws_api_gateway_method_response.options_200]
} */

/* resource "aws_api_gateway_method" "get_s3_api_gateway_method_options" {
    rest_api_id   = aws_api_gateway_rest_api.get_s3_api_gateway.id
    resource_id   = aws_api_gateway_resource.get_s3_api_gateway_resource.id
    http_method   = "OPTIONS"
    authorization = "NONE"
    request_parameters = {
      "method.request.header.Authorization" = false
    }
}

resource "aws_api_gateway_method_response" "options_200" {
    rest_api_id = aws_api_gateway_rest_api.get_s3_api_gateway.id
    resource_id = aws_api_gateway_resource.get_s3_api_gateway_resource.id
    http_method = aws_api_gateway_method.get_s3_api_gateway_method_options.http_method
    status_code = "200"
    response_models = {
      "application/json" = "Empty"
    }

    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Origin" = true
    }

    depends_on = [aws_api_gateway_method.get_s3_api_gateway_method_options]
}

resource "aws_api_gateway_integration" "get_s3_api_gateway_integration_options" {
    rest_api_id             = aws_api_gateway_rest_api.get_s3_api_gateway.id
    resource_id             = aws_api_gateway_resource.get_s3_api_gateway_resource.id
    http_method             = aws_api_gateway_method.get_s3_api_gateway_method_options.http_method
    integration_http_method = "OPTIONS"
    type                    = "MOCK"

    depends_on = [aws_api_gateway_method.get_s3_api_gateway_method_options]
}

resource "aws_api_gateway_integration_response" "get_s3_api_gateway_integration_response_options" {
    rest_api_id         = aws_api_gateway_rest_api.get_s3_api_gateway.id
    resource_id         = aws_api_gateway_resource.get_s3_api_gateway_resource.id
    http_method         = aws_api_gateway_method.get_s3_api_gateway_method_options.http_method
    status_code         = aws_api_gateway_method_response.options_200.status_code

    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
        "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'",
        "method.response.header.Access-Control-Allow-Origin" = "'*'"
    }

    depends_on          = [
      aws_api_gateway_method_response.options_200,
      aws_api_gateway_integration.get_s3_api_gateway_integration_options
    ]
} */

resource "aws_api_gateway_method" "_" {
  rest_api_id   = "${aws_api_gateway_rest_api.get_s3_api_gateway.id}"
  resource_id   = "${aws_api_gateway_resource.get_s3_api_gateway_resource.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# aws_api_gateway_integration._
resource "aws_api_gateway_integration" "_" {
  rest_api_id = "${aws_api_gateway_rest_api.get_s3_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.get_s3_api_gateway_resource.id}"
  http_method = "${aws_api_gateway_method._.http_method}"
  content_handling = "CONVERT_TO_TEXT"

  type = "MOCK"

  request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
}

# aws_api_gateway_integration_response._
resource "aws_api_gateway_integration_response" "_" {
  rest_api_id = "${aws_api_gateway_rest_api.get_s3_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.get_s3_api_gateway_resource.id}"
  http_method = aws_api_gateway_method._.http_method
  status_code = 200

  response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
        "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'",
        "method.response.header.Access-Control-Allow-Origin" = "'*'"
    }

  depends_on = [
    aws_api_gateway_integration._,
    aws_api_gateway_method_response._,
  ]
}

# aws_api_gateway_method_response._
resource "aws_api_gateway_method_response" "_" {
  rest_api_id = "${aws_api_gateway_rest_api.get_s3_api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.get_s3_api_gateway_resource.id}"
  http_method = aws_api_gateway_method._.http_method
  status_code = 200

  response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Origin" = true
    }

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [
    aws_api_gateway_method._,
  ]
}

//
resource "aws_api_gateway_deployment" "aws_api_gateway_deployment_spike" {
  rest_api_id = aws_api_gateway_rest_api.get_s3_api_gateway.id

  triggers = {
    //redeployment = sha1(jsonencode(aws_api_gateway_rest_api.get_s3_api_gateway.body))
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.get_s3_api_gateway_resource,
      aws_api_gateway_method.get_s3_api_gateway_method,
      aws_api_gateway_method._,
      aws_api_gateway_integration.get_s3_api_gateway_integration,
      aws_api_gateway_integration._,
      aws_api_gateway_integration_response.get_s3_api_gateway_integration_response,
      aws_api_gateway_integration_response._,
      aws_api_gateway_method_response.response_200,
      aws_api_gateway_method_response._
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.get_s3_api_gateway_method,
    aws_api_gateway_method._,
    aws_api_gateway_integration.get_s3_api_gateway_integration,
    aws_api_gateway_integration._,
    aws_api_gateway_integration_response.get_s3_api_gateway_integration_response,
    aws_api_gateway_integration_response._,
    aws_api_gateway_method_response.response_200,
    aws_api_gateway_method_response._
  ]
}

//
resource "aws_api_gateway_stage" "aws_api_gateway_stage_spike" {
  deployment_id = aws_api_gateway_deployment.aws_api_gateway_deployment_spike.id
  rest_api_id   = aws_api_gateway_rest_api.get_s3_api_gateway.id
  stage_name    = "dev"
}