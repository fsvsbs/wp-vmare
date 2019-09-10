variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}
variable "vsphere_datacenter" {}
variable "vsphere_cluster" {}
variable "vsphere_network" {}
variable "vsphere_rhel_template" {}
variable "vsphere_wnode_template" {}
variable "vsphere_k8s_folder" {}

variable "ip1" {}
variable "ip2" {}
variable "ip3" {}
variable "ip4" {}
variable "ip5" {}

variable "admin_password" {
    default="Litleco1!"
}
variable "datacenter_code" {
    default = "ukdcl"
}

variable "env_code" {
    default = "tc"
}

variable "dns_suffix_list" {
type="list"
}
variable "ipv4_gateway" {}

variable "dns_server_list" {type="list"}

variable "ipv4_netmask" {}


variable "windows_node_instance_count" {
  default=1
}
variable "linux_node_instance_count" {
  default=1
}
variable "master_node_instance_count" {
  default=1
}
variable "infra_node_instance_count" {
  default=1
}
variable "repo_node_instance_count" {
  default=1
}




