// Create Bucket
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "spike_vue_web" {
  bucket = local.bucket_static_name
}

// Config Web Bucket
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration
resource "aws_s3_bucket_website_configuration" "spike_vue_web_config" {
  bucket = aws_s3_bucket.spike_vue_web.bucket

  index_document {
    suffix = "index.html"
  }
}

// Create Bucket
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "spike_nuxt_web" {
  bucket = local.bucket_static_nuxt_name
}

// Config Web Bucket
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration
resource "aws_s3_bucket_website_configuration" "spike_nuxt_web_config" {
  bucket = aws_s3_bucket.spike_nuxt_web.bucket

  index_document {
    suffix = "index.html"
  }
}

// Create Bucket
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "spike_vue_json" {
  bucket = local.bucket_jsons_files_name
}

// Upload Files to S3 Bucket
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object
resource "aws_s3_object" "web_files" {
    for_each     = fileset("vue/dist", "**")
    bucket       = aws_s3_bucket.spike_vue_web.id
    key          = each.value
    source       = "vue/dist/${each.value}"
    etag         = filemd5("vue/dist/${each.value}")
    content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), null)
}

// Upload Files to S3 Bucket
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object
resource "aws_s3_object" "web_nuxt_files" {
    for_each     = fileset("nuxt/dist", "**")
    bucket       = aws_s3_bucket.spike_nuxt_web.id
    key          = each.value
    source       = "nuxt/dist/${each.value}"
    etag         = filemd5("nuxt/dist/${each.value}")
    content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), null)
}

// Upload Files to S3 Bucket
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object
resource "aws_s3_object" "json_files" {
    for_each = fileset("projections/", "*")
    bucket   = aws_s3_bucket.spike_vue_json.id
    key      = each.value
    source   = "projections/${each.value}"
    etag     = filemd5("projections/${each.value}")
}

// Configure Bucket Policy
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
resource "aws_s3_bucket_policy" "allow_public_access_web" {
  bucket = aws_s3_bucket.spike_vue_web.id
  policy = data.aws_iam_policy_document.allow_public_access_web.json
}

// Configure Bucket Policy
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
resource "aws_s3_bucket_policy" "allow_public_access_web_nuxt" {
  bucket = aws_s3_bucket.spike_nuxt_web.id
  policy = data.aws_iam_policy_document.allow_public_access_web_nuxt.json
}

// Configure Bucket Policy
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
resource "aws_s3_bucket_policy" "allow_public_access_json" {
  bucket = aws_s3_bucket.spike_vue_json.id
  policy = data.aws_iam_policy_document.allow_public_access_json.json
}

data "aws_iam_policy_document" "allow_public_access_web" {
  statement {
    sid = "PublicRead"
    effect        = "Allow"
    principals {
      type = "*"
      identifiers = ["*"]
    }

    actions       = [
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]

    resources     = ["${aws_s3_bucket.spike_vue_web.arn}/*"]
      
  }
}

data "aws_iam_policy_document" "allow_public_access_web_nuxt" {
  statement {
    sid = "PublicRead"
    effect        = "Allow"
    principals {
      type = "*"
      identifiers = ["*"]
    }

    actions       = [
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]

    resources     = ["${aws_s3_bucket.spike_nuxt_web.arn}/*"]
      
  }
}

data "aws_iam_policy_document" "allow_public_access_json" {
  statement {
    sid = "PublicRead"
    effect        = "Allow"
    principals {
      type = "*"
      identifiers = ["*"]
    }

    actions       = [
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]

    resources     = [
      "${aws_s3_bucket.spike_vue_json.arn}/*"
    ]
  }
}