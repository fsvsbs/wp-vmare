

data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

data "vsphere_resource_pool" "pool" {
  name          = "${var.vsphere_cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.vsphere_network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "rhel_template" {
  name          = "${var.vsphere_rhel_template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


data "vsphere_virtual_machine" "wnode_template" {
  name          = "${var.vsphere_wnode_template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
