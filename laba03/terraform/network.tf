resource "yandex_vpc_network" "wp-network" {
  name = "wp-network"
}

resource "yandex_vpc_subnet" "subnet" {
  for_each = {
    "ru-central1-a" = {
      name = "wp-subnet-a"
      v4_cidr_blocks = ["10.2.0.0/16"]
      zone           = "ru-central1-a"
    }
    "ru-central1-b" = {
      name = "wp-subnet-b"
      v4_cidr_blocks = ["10.3.0.0/16"]
      zone           = "ru-central1-b"
    }
    "ru-central1-d" = {
      name = "wp-subnet-d"
      v4_cidr_blocks = ["10.4.0.0/16"]
      zone           = "ru-central1-d"
    }
  }

  name           = each.key
  v4_cidr_blocks = each.value.v4_cidr_blocks
  zone           = each.value.zone
  network_id     = yandex_vpc_network.wp-network.id
}

