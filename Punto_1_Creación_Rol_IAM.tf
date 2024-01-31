# Infraestructura como código (IaC)
# Nicolás Adolfo Castillo Betancourt - nacastillo@bancodeoccidente.com.co
# Ejercicio #1 Creación de Rol IAM


variable "aws_region" {
  default = "us-east-1"
}

variable "role_name" {
  default = "s3-role"
	}

variable "bucket_name" {
  default = "nacastillo-bucket"
	}

provider "aws"{
  region = var.aws_region
}

resource "aws_iam_role" "s3_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
        Service = "s3.amazonaws.com",
    },
      },
   ],
     })
}

# Definiendp los permisos de List
resource "aws_iam_role_policy_attachment" "list_permissions" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ListBucket"
  role       = aws_iam_role.s3_role.name
}

# Definiendo los permisos de Get
resource "aws_iam_role_policy_attachment" "get_permissions" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.s3_role.name
}

# Definiendo los permisos de replicacion de etiquetas
resource "aws_iam_role_policy_attachment" "tag_replication_permissions" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSReplicationRolePolicy"
  role       = aws_iam_role.s3_role.name
}

# Definiendo los permisos de creacion y eliminacion del bucket
resource "aws_iam_role_policy_attachment" "bucket_permissions" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.s3_role.name
}

# Restringiendo permisos de lectura de objetos almacenados
resource "aws_s3_bucket" "nacastillo_bucket" {
  bucket = "nacastillo-bucket"

  acl    = "private"

  # Restringiendo permisos de lectura
  lifecycle_rule {
    enabled = true

    abort_incomplete_multipart_upload_days = 1

    rule {
      id     = "deny-read-access"
      status = "Enabled"

      filter {
        prefix = ""
      }

      expiration {
        days = 1
      }

      noncurrent_version_expiration {
        days = 1
      }
    }
  }
}

# Asociando el IAM Role con el bucket
resource "aws_s3_bucket_policy" "nacastillo_bucket_policy" {
  bucket = aws_s3_bucket.nacastillo_bucket.bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = ["s3:GetObject"],
        Resource = [aws_s3_bucket.nacastillo_bucket.arn],
        Condition = {
          StringNotEqualsIfExists = {
            "aws:PrincipalOrgID" = "o-xxxxxxxxxx",
          },
        },
      },
    ],
  })
}
