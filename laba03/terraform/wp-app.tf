resource "yandex_compute_instance" "wp-app" {
  count = var.host_count
  name = "wp-app-${count.index + 1}"
  zone = var.zones[count.index % 2]

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd80viupr3qjr5g6g9du"
    }
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet[var.zones[count.index % 2]].id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = <<-EOF
      #cloud-config
      packages:
        - nginx
        - curl
      write_files:
        - path: /var/www/html/index.html
          content: |
            <!DOCTYPE html>
            <html>
            <head>
              <title>Web Server ${count.index + 1}</title>
              <style>
                body {
                  font-family: Arial, sans-serif;
                  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                  height: 100vh;
                  display: flex;
                  align-items: center;
                  justify-content: center;
                  color: white;
                  text-align: center;
                }
                .container {
                  background: rgba(255, 255, 255, 0.1);
                  padding: 40px;
                  border-radius: 20px;
                  backdrop-filter: blur(10px);
                }
                h1 {
                  font-size: 3em;
                  margin-bottom: 20px;
                }
                .info {
                  font-size: 1.2em;
                  margin: 10px 0;
                }
              </style>
            </head>
            <body>
              <div class="container">
                <h1> Web Server ${count.index + 1}</h1>
                <div class="info"> Hostname: </div>
                <div class="info"> Zone: ${var.zones[count.index % 2]}</div>
                <div class="info"> Subnet: </div>
                <div class="info"> Date: $(date)</div>
                <div class="info"> Uptime: $(uptime -p)</div>
              </div>
            </body>
            </html>
      runcmd:
        - apt install mysql-client-core-5.7 -y
        - systemctl enable nginx
        - systemctl start nginx
        - echo "Server ${count.index + 1} ready!" > /var/www/server-info.txt
      EOF
  }
}

