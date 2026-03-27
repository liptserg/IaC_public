resource "yandex_vpc_network" "db-network" {
  name = "db-network"
}

resource "yandex_vpc_subnet" "subnet" {
  for_each = {
    "ru-central1-b" = {
      name = "db-subnet-b"
      v4_cidr_blocks = ["10.3.0.0/24"]
      zone           = "ru-central1-b"
    }
    "ru-central1-d" = {
      name = "db-subnet-d"
      v4_cidr_blocks = ["10.4.0.0/24"]
      zone           = "ru-central1-d"
    }
  }

  name           = each.key
  v4_cidr_blocks = each.value.v4_cidr_blocks
  zone           = each.value.zone
  network_id     = yandex_vpc_network.db-network.id
}

