terraform {
  backend "s3" {
    bucket = "tf-bucket-bart"
    key    = "terraform.tfstate"
    region = "eu-north-1"
  }
}
