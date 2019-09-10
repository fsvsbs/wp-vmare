resource "vsphere_virtual_machine" "linux_node" {
  count            = "${var.linux_node_instance_count}"
  name             = "${var.datacenter_code}-${var.env_code}-n${count.index}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"

  folder           = "${var.vsphere_k8s_folder}"

  num_cpus = 2
  memory   = 4096
  guest_id = "${data.vsphere_virtual_machine.rhel_template.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.rhel_template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.rhel_template.disks.0.size}"
    unit_number      = 0
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.rhel_template.id}"

    customize {
      linux_options {
        host_name = "${var.datacenter_code}-${var.env_code}-n${count.index}"
        domain    = "${var.dns_suffix_list[0]}"
      }

      network_interface {
        ipv4_address = "${var.ip3}"
        ipv4_netmask = "${var.ipv4_netmask}"
      }

      ipv4_gateway = "${var.ipv4_gateway}"
      dns_suffix_list = "${var.dns_suffix_list}"
      dns_server_list = "${var.dns_server_list}"
    }
  }
}

resource "null_resource" "linux_node_testing" {
    count = "${var.linux_node_instance_count}"
    provisioner "local-exec" {
        command = <<EOT
          echo ${element(vsphere_virtual_machine.linux_node.*.default_ip_address, count.index)}
        EOT
    }
}