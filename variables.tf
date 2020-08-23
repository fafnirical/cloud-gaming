variable "region" {
  type        = string
  description = "The AWS region to launch the cloud gaming instance in"
  default     = "us-west-2"
  validation {
    condition = contains(
      [
        "us-east-1",
        "us-east-2",
        "us-west-1",
        "us-west-2",
        "ca-central-1",
        "eu-central-1",
        "eu-west-1",
        "eu-west-2",
        "eu-west-3",
        "eu-north-1",
        "eu-south-1",
        "ap-east-1",
        "ap-southeast-1",
        "ap-southeast-2",
        "ap-northeast-2",
        "ap-northeast-1",
        "ap-south-1",
        "sa-east-1",
        "me-south-1",
        "af-south-1",
      ],
      var.region
    )
    error_message = "The region value must be a valid AWS region."
  }
}

variable "amis" {
  type        = map(string)
  description = "The mapping of region to Windows Server 2019 Base AMI. The list can be found here: https://aws.amazon.com/marketplace/server/configuration?productId=ef297a90-3ad0-4674-83b4-7f0ec07c39bb"
  default = {
    "us-east-1"      = "ami-032c2c4b952586f02"
    "us-east-2"      = "ami-0239d3998515e9ed1"
    "us-west-1"      = "ami-08bcc13ad2c143073"
    "us-west-2"      = "ami-029e27fb2fc8ce9d8"
    "ca-central-1"   = "ami-016197fd71780ca55"
    "eu-central-1"   = "ami-097d8d0112fa53f4d"
    "eu-west-1"      = "ami-0b5271aea7b566f9a"
    "eu-west-2"      = "ami-05a319a41425b5c2f"
    "eu-west-3"      = "ami-0877824261c6d4fba"
    "eu-north-1"     = "ami-0ce749ed317f374a5"
    "eu-south-1"     = "ami-05d652c60d9d1737d"
    "ap-east-1"      = "ami-050cae5899120aef4"
    "ap-southeast-1" = "ami-0347ec7904d48c572"
    "ap-southeast-2" = "ami-0343f4bc3607550d2"
    "ap-northeast-2" = "ami-0769516a1517adf13"
    "ap-northeast-1" = "ami-0e9015afafe841ca7"
    "ap-south-1"     = "ami-07f7b791cbd0812bf"
    "sa-east-1"      = "ami-08c4c4704553db9da"
    "me-south-1"     = "ami-02e23331da53d6fab"
    "af-south-1"     = "ami-0f8a986c4c487bc80"
  }
}

variable "instance_type" {
  type        = string
  description = "The instance type for the cloud gaming system. A g4dn instance type is recommended."
  default     = "t3a.nano" # TODO: Switch to g4dn.xlarge
}

data "http" "my_public_ip" {
  url = "https://ifconfig.co/json"
  request_headers = {
    "Accept" = "application/json"
  }
}

locals {
  my_public_ip = jsondecode(data.http.my_public_ip.body).ip
}
