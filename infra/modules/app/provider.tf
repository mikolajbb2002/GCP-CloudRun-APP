provider "google" {
  # Project is taken from env variable:  GOOGLE_PROJECT.
  region = var.region
}
