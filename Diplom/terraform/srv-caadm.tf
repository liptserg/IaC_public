resource "yandex_compute_instance" "ca-adm" {
  name = "srv-ca-adm"
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
	ip_address = "10.3.0.31"
  }

  metadata = {
    user-data = <<-EOF
      #cloud-config
      users:
        - name: user01
          sudo: 'ALL=(ALL) NOPASSWD:ALL'
          shell: /bin/bash
        - name: caadmin
          sudo: 'ALL=(ALL) NOPASSWD:ALL'
          shell: /bin/bash
      EOF
    ssh-keys = "user01:${file("~/.ssh/id_rsa.pub")}"
  }
  
  connection {
    type = "ssh"
    user = "user01"
    private_key = file("~/.ssh/id_rsa") # Закрытый ключ администратора
    host = self.network_interface[0].nat_ip_address
	port = 22
    timeout = "2m"
  }
  
  # Копирование закрытого ключа пользователя user01
  provisioner "file" {
    source = "~/.ssh/id_rsa"
    destination = "/home/user01/.ssh/id_rsa"
  }  
  
  # Копирование закрытого ключа для нового пользователя
  provisioner "file" {
    source = "../key/caadmin"
    destination = "/home/user01/.ssh/caadmin"
  }  

  # Копирование открытого ключа для нового пользователя
  provisioner "file" {
    source = "../key/caadmin.pub"
    destination = "/home/user01/.ssh/caadmin.pub"
  }     

  provisioner "remote-exec" {
    inline = [     
      "sudo apt-get update",
	    "sudo apt-get install -y postgresql-client",
      "sudo timedatectl set-timezone Europe/Moscow",
	    "sudo mkdir -p /home/caadmin/.ssh ", 
      "sudo cp /home/user01/.ssh/caadmin /home/caadmin/.ssh/id_rsa",
      "sudo cp /home/user01/.ssh/caadmin.pub /home/caadmin/.ssh/authorized_keys",
      "sudo chown -R caadmin:caadmin /home/caadmin/.ssh",
      "sudo chmod 600 /home/caadmin/.ssh/authorized_keys",
      "sudo chmod 600 /home/caadmin/.ssh/id_rsa",
      "sudo chmod 600 /home/user01/.ssh/id_rsa",
      "sudo hostnamectl set-hostname srv-caadm",
      "sudo sed -i 's/127.0.0.1[[:space:]].*/127.0.0.1 localhost srv-caadm/g' /etc/hosts",
      "sudo rm /home/user01/.ssh/caadmin*"
    ]
  }
  
}
