resource "vsphere_virtual_machine" "windows_node" {
  count            = "${var.windows_node_instance_count}"
  name             = "${var.datacenter_code}-${var.env_code}-w${count.index}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"

  folder           = "${var.vsphere_k8s_folder}"

  num_cpus = 2
  memory   = 4096
  guest_id = "${data.vsphere_virtual_machine.wnode_template.guest_id}"
  firmware = "${data.vsphere_virtual_machine.wnode_template.firmware}"

  scsi_type = "${data.vsphere_virtual_machine.wnode_template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.wnode_template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.wnode_template.disks.0.size}"
    thin_provisioned = "${data.vsphere_virtual_machine.wnode_template.disks.0.thin_provisioned}"
    unit_number      = 0
  }

  disk {
    label            = "disk1"
    size             = "${data.vsphere_virtual_machine.wnode_template.disks.1.size}"
    thin_provisioned = "${data.vsphere_virtual_machine.wnode_template.disks.1.thin_provisioned}"
    unit_number      = 1
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.wnode_template.id}"

    customize {
      windows_options {
        computer_name  = "${var.datacenter_code}-${var.env_code}-w${count.index}"
        admin_password = "${var.admin_password}"
      }

      network_interface {
        ipv4_address = "${var.ip4}"
        ipv4_netmask = "${var.ipv4_netmask}"
      }

      ipv4_gateway = "${var.ipv4_gateway}"
      dns_suffix_list = "${var.dns_suffix_list}"
      dns_server_list = "${var.dns_server_list}"
    }
  }
}

resource "null_resource" "windows_node_testing" {
    count = "${var.windows_node_instance_count}"
    #depends_on = 
    provisioner "local-exec" {
        command = <<EOT
          echo ${element(vsphere_virtual_machine.windows_node.*.default_ip_address, count.index)}
        EOT
    }
    
}