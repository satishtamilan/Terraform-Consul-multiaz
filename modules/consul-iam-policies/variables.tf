variable "iam_role_id" {
  description = "The ID of the IAM Role to which these IAM policies should be attached"
  type        = string
}

variable "enabled" {
  description = "Give the option to disable this module if required"
  type        = bool
  default     = true
}

