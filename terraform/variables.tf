variable "vpc_cidr" {
  default     = "10.0.0.0/16"
}

variable "rt_wide_route" {
  default     = "0.0.0.0/0"
}

variable "public_cidrs" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "private_cidrs" {
  default = [
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
}

variable "flask_app_image" {
  default = "/api"
}

variable "flask_app_port" {
  default = 5000
}

variable "flask_env" {
  default = "development"
}

variable "flask_app" {
  default = "api"
}

variable "flask_app_home" {
  default = "/Users/DELL/Documents/GitHub/test-project/api/"
}

variable "postgres_db_port" {
  description = "Port exposed by the RDS instance"
  default = 5432
}

variable "rds_instance_type" {
  description = "Instance type for the RDS database"
  default = "db.t2.micro"
}


variable "sys-stats_app_image" {
  default = "/sys-stats"
}

variable "sys-stats_app_port" {
  default = 3000
}

variable "sys-stats_env" {
  default = "development"
}

variable "sys-stats_app" {
  default = "sys-stats"
}

variable "sys-stats_app_home" {
  default = "/Users/DELL/Documents/GitHub/test-project/sys-stats/"
}


variable "nginx_app_image" {
  default = "/nginx"
}

variable "nginx_app_port" {
  default = 80
}

variable "nginx_env" {
  default = "development"
}

variable "nginx_app" {
  default = "nginx"
}

variable "nginx_app_home" {
  default = "/Users/DELL/Documents/GitHub/test-project/nginx/"
}