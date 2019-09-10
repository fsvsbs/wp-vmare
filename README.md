# iac-k8s-terraform
Kubernetes Terraform ( all Stages change Variables)

Example Variables

Stage 0

    ---
    terraform_vars:
      vsphere_server: "ukdcl-ic-vcs01.test-lab.local"
      vsphere_datacenter: "iac-lab"
      vsphere_cluster: "cls01/Resources"
      vsphere_network: "Existing-LAB-Network|AP-EXISTING-LAB|SERVICES-124-LAB"
      vsphere_rhel_template: "standard rhel 7"
      vsphere_wnode_template: "iaas-template-imf-x64-win2019-core-20190709-1908"
      vsphere_k8s_folder: "JB/K8S"
      datacenter_code: "ukdcl"
      ip1: "10.240.29.158"
      ip2: "10.240.29.159"
      ip4: "10.240.29.161"
      ip5: "10.240.29.162"
      env_code: "iac-k8s"
      dns_suffix_list: '["test-lab.local"]'
      ipv4_gateway: "10.240.24.1"
      dns_server_list: '["10.240.32.20", "10.240.32.22"]'
      ipv4_netmask: "21"
    
    
    terraform_bin: /root/git/terraform
    tf_plugin: "{{role_path}}/vmware/"



The test cluster in `Stage 0` (Walbrook Building) will have the following VMs:


* '*[datacenter_code]*-*[env_code]*-i*[infra_node_instance_count]*.*[domain]*' - Redhat 7.6 Host VMs running:
  * **ingress** routers - platform deployed HAproxy that are watching **etcd** for service and pod changes to route to the right pods
  * **Monitoring** - including `Prometheus`, `Alertmanager` and `Grafana`
  * **Registry** - holding the client build containers
* '*[datacenter_code]*-*[env_code]*-m*[infra_node_instance_count]*.*[domain]*' - Redhat 7.6 Host VMs running:
  * `API Server` - `oc` or `kubectl` interacts with this API
  * `Controller Manager Server` - watches **etcd** for changes
  * `etcd` - service discovery and configuration persistence distributed database - in latest versions of Openshift the recommandation is to colocate etcd with masters.Potentially super large K8s cluster can benefit from separate etcd but this requires separate setup and integration.

* '*[datacenter_code]*-*[env_code]*-n*[infra_node_instance_count]*.*[domain]*' - Redhat 7.6 Host VMs running the non infrastructure client containers.

* '*[datacenter_code]*-*[env_code]*-w*[infra_node_instance_count]*.*[domain]*' - Windows 1809 Host VMs running the non infrastructure client containers.



To Be Created/Developed
* `rc-rhel-l1.test-lab.local` - RHEL VM running the top HAproxy for Master API (with each of the 3 masters behind listening on port 8443) plus **HTTP** and **HTTPS** towards the 2 **ingress** routers running on the 2 infrastructure VMs




Several files/folders are added to `.gitignore`:
* `secret.tfvars` - holding the `vsphere_password` password for `svc_packer` user
* `terraform.tfstate*` - mapping to `terraform.tfstate` and `terraform.tfstate.backup` files that store vmware state and don't need to be commited to Git
* `.terraform/` - folder holding the Terraform specific plugin symlink (or binary in the worse case) like `.terraform/plugins/linux_amd64/lock.json`

