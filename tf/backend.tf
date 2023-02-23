terraform {
  backend "s3" {
    bucket = "tf-bucket-bart"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
