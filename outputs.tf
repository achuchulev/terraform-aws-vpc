output "vpc_id" {
  value = "${aws_vpc.new_vpc.id}"
}

output "vpc_name" {
  value = "${aws_vpc.new_vpc.tags.Name}"
}

output "subnet_ids" {
  value = "${aws_subnet.vpc_subnet.*.id}"
}
