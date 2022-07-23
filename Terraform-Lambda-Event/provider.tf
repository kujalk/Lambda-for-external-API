provider "aws" {
  region                   = var.region
  shared_credentials_files = ["C:\\Users\\Test\\.aws\\credentials"]
  profile                  = "Test"
}
