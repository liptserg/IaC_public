resource "yandex_compute_instance" "srv-db" {
  count = var.host_count
  name = "srv-db0${count.index + 1}"
  zone = var.zones[0]

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }
  
  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "fd8c94c2kbrutuj9pt4d"
    }
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet[var.zones[0]].id
    nat       = true
	ip_address = "10.3.0.2${count.index + 1}"
  }

  metadata = {
    user-data = <<-EOF
      #cloud-config
      users:
        - name: user01
          sudo: 'ALL=(ALL) NOPASSWD:ALL'
          shell: /bin/bash
      write_files:
        - path: "/usr/local/etc/startup.sh"
          permissions: "755"
          content: |
            #!/bin/bash

            my_hostname="srv-db$(hostname -I|cut -d'.' -f4|cut -d' ' -f1)"
            apt-get update
            apt-get install -y etcd
            apt-get install -y patroni
            apt-get install -y postgresql
            apt-get install -y keepalived
            hostnamectl set-hostname $my_hostname
            sed -i "s/127.0.0.1[[:space:]].*/127.0.0.1 localhost $my_hostname/g" /etc/hosts
          defer: true
      runcmd:
        - ["/usr/local/etc/startup.sh"]
      packages:
        - yq
      EOF
    ssh-keys = "user01:${file("~/.ssh/id_rsa.pub")}"
  }
  
}

