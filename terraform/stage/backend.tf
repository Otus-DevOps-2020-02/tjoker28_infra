terraform {
  backend "gcs" {
    bucket = "my-homework7-bucket"
    prefix = "stage"
  }
}
