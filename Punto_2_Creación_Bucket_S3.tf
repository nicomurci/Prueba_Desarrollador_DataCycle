# Infraestructura como código (IaC)
# Nicolás Adolfo Castillo Betancourt - nacastillo@bancodeoccidente.com.co
# Ejercicio #2 Creación Bucket S3


provider "aws" {
  region = "us-east-1"
}

variable "bucket_name" {
  description = "Nombre del bucket S3"
  default     = "nacastillo-bucket"
}

resource "aws_s3_bucket" "nacastillo_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    enabled = true

    expiration {
      days = 15
    }
  }
}
