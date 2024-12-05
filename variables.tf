variable "aws_region" {
    description = "region"
    type        = string
    default     = "" # change it
}

variable "bucket_name" {
    description = "bucket name for machine learning"
    type        = string
    default     = "" # change it
}

variable "bucket_object_tokyo" {
    description = "tokyo csv content for machine learning"
    type        = string
    default     = "resource/tokyo_analytics.csv"
}

variable "bucket_object_sapporo" {
    description = "tokyo csv content for machine learning"
    type        = string
    default     = "resource/sapporo_analytics.csv"
}

variable "notebook_instance_name" {
    description = "notebook instance namse for machine learning"
    type        = string
    default     = "" # change it
}
