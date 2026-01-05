variable "yc_cloud" {
  type = string
  description = "Yandex Cloud ID"
}

variable "yc_folder" {
  type = string
  description = "Yandex Cloud folder"
}

variable "yc_token" {
  type = string
  description = "Yandex Cloud OAuth token"
}

variable "db_password" {
  description = "MySQL user pasword"
}

variable "host_count" {
  type = number
  description = "number of hosts"
  default = 2
}

variable "zones" {
  description = "List of zones"
  type        = list(string)
  #default     = ["ru-central1-a", "ru-central1-b", "ru-central1-d"] 
  default     = ["ru-central1-a", "ru-central1-b"]
}

