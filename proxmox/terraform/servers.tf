# Production Servers
# ---

resource "proxmox_vm_qemu" "srv-prod-1" {
    name = "srv-prod-1"
    desc = "Server Production 1, Main Application Server, Ubuntu LTS"
    agent = 1
    target_node = "prx-prod-2"

    tags = "docker"

    onboot = true
    automatic_reboot = true
    qemu_os = "other"

    # -- only important for full clone
    # vmid = 20002
    # clone = "ubuntu-server-test-1"
    # full_clone = true
    full_clone = false
    define_connection_info = false
    oncreate = false

    cores = 3
    sockets = 1
    cpu = "host"
    memory = 6144

    network {
        bridge = "vmbr1"
        model  = "virtio"
    }

    scsihw = "virtio-scsi-pci"

    disk {
        storage = "pv1"
        type = "virtio"
        size = "40G"
        iothread = 1
        volume = "pv1:vm-20002-disk-0"
    }

    lifecycle {
        ignore_changes = [
            disk
        ]
    }

    # Cloud Init Settings 
    os_type = "cloud-init" 
    ipconfig0 = "ip=10.20.0.2/16,gw=10.20.0.1"
    nameserver = "10.20.0.1"
    ciuser = "xcad"
    sshkeys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsYvxYCpI90al2rJiyccPYNrvjHKLhvgTJVDssAL29jAPhl46gQctL98yZ+Rx9E3dLiHhs8SP14X2m50XbxX+QnjEjq2ywCqu359YMiitvaOgWMzKIaeiwnDngHc5NY+eC8t88bhhKmQPjejmdLSApLu7ObJ/9by2fjWptmqrkkhc1WQs58oYwNDenOd9UNaWcXtyPf2AGIIze2r1cFaEwAPyNtTlzCeqj41jKHLYorvU0CU5KUqgcgswXSgOC+moYac4WIUJCZCCU/s354NpKcJMYN/eiEpK1nZR/jhIe/pEsG4oIbCHy7f+PZruNhF6hi8UvhT+MHS0wwID/gj+UQPyg9GVieiQ1hv+NpLImkTdVJKemMf02548jEPhcrgLowuBemvtf4NHJE0FUH3chTu/Ioi66XKiedWdHMGLTBlWIUMuIYzHeFWLzCg8BqpQK0D7H48W7aku6JgWfhBdy5COvaglpRxlTAac8KURNtR1FRjxX9Lh1hHU+i5nLhIc= WSL2/XWIN
    EOF
}

resource "proxmox_vm_qemu" "srv-prod-2" {
    name = "srv-prod-2"
    desc = "Server Production 2, Main Database Server, Ubuntu LTS"
    agent = 1
    target_node = "prx-prod-2"

    tags = "docker"

    onboot = true
    startup = "order=2,up=10"
    automatic_reboot = true
    qemu_os = "other"

    # -- only important for full clone
    # vmid = 20002
    # clone = "ubuntu-server-test-1"
    # full_clone = true
    full_clone = false
    define_connection_info = false
    oncreate = false

    cores = 1
    sockets = 1
    cpu = "host"
    memory = 2048

    network {
        bridge = "vmbr1"
        model  = "virtio"
    }

    scsihw = "virtio-scsi-pci"

    disk {
        storage = "pv1"
        type = "virtio"
        size = "40G"
        iothread = 1
        volume = "pv1:vm-20003-disk-0"
    }

    lifecycle {
        ignore_changes = [
            disk
        ]
    }

    # Cloud Init Settings 
    os_type = "cloud-init" 
    ipconfig0 = "ip=10.20.0.3/16,gw=10.20.0.1"
    nameserver = "10.20.0.1"
    ciuser = "xcad"
    sshkeys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsYvxYCpI90al2rJiyccPYNrvjHKLhvgTJVDssAL29jAPhl46gQctL98yZ+Rx9E3dLiHhs8SP14X2m50XbxX+QnjEjq2ywCqu359YMiitvaOgWMzKIaeiwnDngHc5NY+eC8t88bhhKmQPjejmdLSApLu7ObJ/9by2fjWptmqrkkhc1WQs58oYwNDenOd9UNaWcXtyPf2AGIIze2r1cFaEwAPyNtTlzCeqj41jKHLYorvU0CU5KUqgcgswXSgOC+moYac4WIUJCZCCU/s354NpKcJMYN/eiEpK1nZR/jhIe/pEsG4oIbCHy7f+PZruNhF6hi8UvhT+MHS0wwID/gj+UQPyg9GVieiQ1hv+NpLImkTdVJKemMf02548jEPhcrgLowuBemvtf4NHJE0FUH3chTu/Ioi66XKiedWdHMGLTBlWIUMuIYzHeFWLzCg8BqpQK0D7H48W7aku6JgWfhBdy5COvaglpRxlTAac8KURNtR1FRjxX9Lh1hHU+i5nLhIc= WSL2/XWIN
    EOF
}

resource "proxmox_vm_qemu" "srv-prod-3" {
    name = "srv-prod-3"
    desc = "Kubernetes Production 1 Control-Plane Master 1, Ubuntu LTS"
    agent = 1
    target_node = "prx-prod-2"

    tags = "kube"

    onboot = true
    startup = "order=3,up=10"
    automatic_reboot = true
    qemu_os = "l26"

    # -- only important for full clone
    # vmid = 20002
    # clone = "ubuntu-server-test-1"
    # full_clone = true
    full_clone = false
    define_connection_info = false
    oncreate = false

    cores = 1
    sockets = 1
    cpu = "host"
    memory = 2048

    network {
        bridge = "vmbr1"
        model  = "virtio"
    }

    scsihw = "virtio-scsi-pci"

    disk {
        storage = "pv1"
        type = "virtio"
        size = "32G"
        iothread = 1
        volume = "pv1:vm-20015-disk-0"
    }

    lifecycle {
        ignore_changes = [
            disk
        ]
    }
}

resource "proxmox_vm_qemu" "srv-prod-4" {
    name = "srv-prod-4"
    desc = "Kubernetes Production 1 Control-Plane Master 2, Ubuntu LTS"
    agent = 1
    target_node = "prx-prod-2"

    tags = "kube"

    onboot = true
    startup = "order=3,up=10"
    automatic_reboot = true
    qemu_os = "l26"

    # -- only important for full clone
    # vmid = 20002
    # clone = "ubuntu-server-test-1"
    # full_clone = true
    full_clone = false
    define_connection_info = false
    oncreate = false

    cores = 1
    sockets = 1
    cpu = "host"
    memory = 2048

    network {
        bridge = "vmbr1"
        model  = "virtio"
    }

    scsihw = "virtio-scsi-pci"

    disk {
        storage = "pv1"
        type = "virtio"
        size = "32G"
        iothread = 1
        volume = "pv1:vm-20016-disk-0"
    }

    lifecycle {
        ignore_changes = [
            disk
        ]
    }
}

resource "proxmox_vm_qemu" "srv-prod-5" {
    name = "srv-prod-5"
    desc = "Kubernetes Production 1 Worker Node 1, Ubuntu LTS"
    agent = 1
    target_node = "prx-prod-2"

    tags = "kube"

    onboot = true
    startup = "order=3,up=10"
    automatic_reboot = true
    qemu_os = "l26"

    # -- only important for full clone
    # vmid = 20002
    # clone = "ubuntu-server-test-1"
    # full_clone = true
    full_clone = false
    define_connection_info = false
    oncreate = false

    cores = 4
    sockets = 1
    cpu = "host"
    memory = 8192

    network {
        bridge = "vmbr1"
        model  = "virtio"
    }

    scsihw = "virtio-scsi-pci"

    disk {
        storage = "pv1"
        type = "virtio"
        size = "32G"
        iothread = 1
        volume = "pv1:vm-20017-disk-0"
    }

    lifecycle {
        ignore_changes = [
            disk
        ]
    }
}

resource "proxmox_vm_qemu" "srv-prod-6" {
    name = "srv-prod-6"
    desc = "Kubernetes Production 1 Worker Node 2, Ubuntu LTS"
    agent = 1
    target_node = "prx-prod-2"

    tags = "kube"

    onboot = true
    startup = "order=3,up=10"
    automatic_reboot = true
    qemu_os = "l26"

    # -- only important for full clone
    # vmid = 20002
    # clone = "ubuntu-server-test-1"
    # full_clone = true
    full_clone = false
    define_connection_info = false
    oncreate = false

    cores = 4
    sockets = 1
    cpu = "host"
    memory = 8192

    network {
        bridge = "vmbr1"
        model  = "virtio"
    }

    scsihw = "virtio-scsi-pci"

    disk {
        storage = "pv1"
        type = "virtio"
        size = "32G"
        iothread = 1
        volume = "pv1:vm-20018-disk-0"
    }

    lifecycle {
        ignore_changes = [
            disk
        ]
    }
}

# Demo Servers
# ---

resource "proxmox_vm_qemu" "srv-demo-1" {
    name = "srv-demo-1"
    desc = "Server Demo 1, Application Testing Server, Ubuntu LTS"
    agent = 1
    target_node = "prx-prod-2"

    tags = "docker"

    onboot = true
    automatic_reboot = true
    qemu_os = "other"

    # -- only important for full clone
    # vmid = 20002
    # clone = "ubuntu-server-test-1"
    # full_clone = true
    full_clone = false
    define_connection_info = false
    oncreate = false

    cores = 1
    sockets = 1
    cpu = "host"
    memory = 1024

    network {
        bridge = "vmbr1"
        model  = "virtio"
    }

    scsihw = "virtio-scsi-pci"

    disk {
        storage = "pv1"
        type = "virtio"
        size = "20G"
        iothread = 1
        volume = "pv1:vm-23001-disk-0"
    }

    lifecycle {
        ignore_changes = [
            disk
        ]
    }

    # Cloud Init Settings 
    os_type = "cloud-init" 
    ipconfig0 = "ip=10.20.3.1/16,gw=10.20.0.1"
    nameserver = "10.20.0.1"
    ciuser = "xcad"
    sshkeys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsYvxYCpI90al2rJiyccPYNrvjHKLhvgTJVDssAL29jAPhl46gQctL98yZ+Rx9E3dLiHhs8SP14X2m50XbxX+QnjEjq2ywCqu359YMiitvaOgWMzKIaeiwnDngHc5NY+eC8t88bhhKmQPjejmdLSApLu7ObJ/9by2fjWptmqrkkhc1WQs58oYwNDenOd9UNaWcXtyPf2AGIIze2r1cFaEwAPyNtTlzCeqj41jKHLYorvU0CU5KUqgcgswXSgOC+moYac4WIUJCZCCU/s354NpKcJMYN/eiEpK1nZR/jhIe/pEsG4oIbCHy7f+PZruNhF6hi8UvhT+MHS0wwID/gj+UQPyg9GVieiQ1hv+NpLImkTdVJKemMf02548jEPhcrgLowuBemvtf4NHJE0FUH3chTu/Ioi66XKiedWdHMGLTBlWIUMuIYzHeFWLzCg8BqpQK0D7H48W7aku6JgWfhBdy5COvaglpRxlTAac8KURNtR1FRjxX9Lh1hHU+i5nLhIc= WSL2/XWIN
    EOF
}

resource "proxmox_vm_qemu" "srv-demo-2" {
    name = "srv-demo-2"
    desc = "Kubernetes Demo 1 Control-Plane Master 1, Ubuntu LTS"
    agent = 1
    target_node = "prx-prod-2"

    tags = "kube"

    onboot = true
    automatic_reboot = true
    qemu_os = "l26"

    # -- only important for full clone
    # vmid = 20002
    # clone = "ubuntu-server-test-1"
    # full_clone = true
    full_clone = false
    define_connection_info = false
    oncreate = false

    cores = 1
    sockets = 1
    cpu = "host"
    memory = 2048

    network {
        bridge = "vmbr1"
        model  = "virtio"
    }

    scsihw = "virtio-scsi-pci"

    disk {
        storage = "pv1"
        type = "virtio"
        size = "42G"
        iothread = 1
        volume = "pv1:vm-23004-disk-0"
    }

    lifecycle {
        ignore_changes = [
            disk
        ]
    }
}

resource "proxmox_vm_qemu" "srv-demo-3" {
    name = "srv-demo-3"
    desc = "Kubernetes Demo 1 Worker Node 1, Ubuntu LTS"
    agent = 1
    target_node = "prx-prod-2"

    tags = "kube"

    onboot = true
    automatic_reboot = true
    qemu_os = "l26"

    # -- only important for full clone
    # vmid = 20002
    # clone = "ubuntu-server-test-1"
    # full_clone = true
    full_clone = false
    define_connection_info = false
    oncreate = false

    cores = 2
    sockets = 1
    cpu = "host"
    memory = 4096

    network {
        bridge = "vmbr1"
        model  = "virtio"
    }

    scsihw = "virtio-scsi-pci"

    disk {
        storage = "pv1"
        type = "virtio"
        size = "40G"
        iothread = 1
        volume = "pv1:vm-23005-disk-0"
    }

    lifecycle {
        ignore_changes = [
            disk
        ]
    }
}

resource "proxmox_vm_qemu" "srv-demo-4" {
    name = "srv-demo-4"
    desc = "Kubernetes Demo 2 Single Node, Ubuntu LTS"
    agent = 1
    target_node = "prx-prod-2"

    tags = "kube"

    onboot = true
    automatic_reboot = true
    qemu_os = "l26"

    # -- only important for full clone
    # vmid = 20002
    # clone = "ubuntu-server-test-1"
    # full_clone = true
    full_clone = false
    define_connection_info = false
    oncreate = false

    cores = 2
    sockets = 1
    cpu = "host"
    memory = 4096

    network {
        bridge = "vmbr1"
        model  = "virtio"
    }

    scsihw = "virtio-scsi-pci"

    disk {
        storage = "pv1"
        type = "virtio"
        size = "32G"
        iothread = 1
        volume = "pv1:vm-23006-disk-0"
    }

    lifecycle {
        ignore_changes = [
            disk
        ]
    }
}
