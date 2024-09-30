variable "gcp_project" {
  description = "Google Cloud Platform project ID (not project number)"
  type        = string
}

variable "gcp_location" {
  description = "Google Cloud Platform location code"
  type        = string
  default     = "us-central1"
}
