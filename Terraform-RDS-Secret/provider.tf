provider "aws" {
  region                   = var.region
  shared_credentials_files = ["C:\\Users\\user\\.aws\\credentials"]
  profile                  = "Test"
}
