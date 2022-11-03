// Create Role
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "admin_role" {
    name = "VueRole"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Action    = "sts:AssumeRole"
            Effect    = "Allow"
            Sid       = ""
            Principal = {
                Service   = "lambda.amazonaws.com"
            }
        },
        ]
    })
    // Set Permissions
    managed_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", 
        "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess",
        "arn:aws:iam::aws:policy/AWSLambdaInvocation-DynamoDB"]
}