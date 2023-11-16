variable "service_name" {
  description = "Navn på App Runner service"
  type        = string
  default     = "default-service-name"
}

variable "iam_role_name" {
  description = "Navn på IAM Rollen for App Runner Service"
  type        = string
  default     = "default-iam-role-name"
}

variable "iam_policy_name" {
  description = "Navn på IAM Policy for App Runner Service"
  type        = string
  default     = "default-iam-policy-name"
}