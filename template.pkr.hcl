source "proxmox-clone" "ubuntu-server-22-04-lts" {
  proxmox_url              = "${var.proxmox_api_url}"
  username                 = "${var.proxmox_api_token_id}"
  token                    = "${var.proxmox_api_token_secret}"
  insecure_skip_tls_verify = true

  node     = "${var.proxmox_node}"
  clone_vm = "ubuntu-server-22-04-lts"

  vm_name              = "k8s-master-node"
  template_description = "k8s master node"

  cores  = "1"
  memory = "2048"

  ssh_username = "${var.ssh_username}"
}

build {
  sources = [
    "source.proxmox-clone.ubuntu-server-22-04-lts"
  ]

  # wait for cloud-init to finish
  provisioner "shell" {
    inline_shebang = "/bin/sh -x"
    inline = [
      "while ! cloud-init status | grep -q 'done'; do echo 'Waiting for cloud-init...'; sleep 5s; done"
    ]
    only = ["proxmox-clone.ubuntu-server-22-04-lts"]
  }

  # update and install ansible
  provisioner "shell" {
    inline_shebang = "/bin/sh -x"
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt-get install ansible -y"
    ]
  }

  // # run ansible playbook
  // provisioner "ansible-local" {
  //   playbook_file = "./playbooks/provision-k8s-master-node.yml"
  //   extra_arguments = []
  // }

  # cleanups
  provisioner "shell" {
    inline_shebang = "/bin/sh -x"
    inline = [
      "sudo apt-get purge ansible -y"
    ]
  }

  # proxmox cleanup
  provisioner "shell" {
    inline_shebang = "/bin/sh -x"
    inline = [ 
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt-get autoremove --purge -y",
      "sudo apt-get clean -y ",
      "sudo apt-get autoclean -y",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo sync"
    ]
    only = ["proxmox-clone.ubuntu-server-22-04-lts"]
  }
}