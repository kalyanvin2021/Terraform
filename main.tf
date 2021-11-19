# aws provider

provider "aws" {
  region = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Creating the snapshots of multiple EBS volumes

variable "ebs_volumes" {
  default = [
    "EBS1",
    "EBS2",
  ]
}
data "aws_ebs_volume" "ebs_volumes" {
  count = "${length(var.ebs_volumes)}"

  filter {
    name   = "tag:Name"
    values = ["${var.ebs_volumes[count.index]}"]
  }
}
output "ebs_volume_ids" {
  value = ["${data.aws_ebs_volume.ebs_volumes.*.id}"]
}

resource "aws_ebs_snapshot" "ebs_volumes" {
  count     = "${length(var.ebs_volumes)}"
  volume_id = "${data.aws_ebs_volume.ebs_volumes.*.id[count.index]}"
}
