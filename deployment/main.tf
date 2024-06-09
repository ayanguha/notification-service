// provider setup

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.4.2"
    }
  }
}

provider "aws" {
  region  = "ap-southeast-2"
  profile = "modelapi"
}

resource "random_string" "suffix" {
  length = 16
  lower  = true
  special = false
  numeric = false
  upper = false 
}



data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


