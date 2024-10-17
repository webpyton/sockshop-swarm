terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~>0.65.0"
    }
  }
}
provider "yandex" {
  token     = "t1.9euelZqLy4vNmImVz4qKzseSy8aeiu3rnpWazMrLyJ6Nk82Kj83Hi5uNzM3l8_cja1FH-e9lM0Bp_d3z92MZT0f572UzQGn9zef1656VmszGycmdz5qeipeUkJ2OkIyR7_zN5_XrnpWanMabkpKUlZzLxpqTmJuOy5Tv_cXrnpWazMbJyZ3Pmp6Kl5SQnY6QjJE.msjEKX1yMHAa_7UEczPT4q0PqMUz1OBl-1mmIxivPGoa-mVpFYsBx103UKhFD1JrTNzC35D1npMo5YreC0r8AA"
  cloud_id  = "b1gvilug5fqakb1f6g6a"
  folder_id = "b1glnha7m55dvjf74b0k"
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "network" {
  name = "swarm-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

module "swarm_cluster" {
  source        = "./modules/instance"
  vpc_subnet_id = yandex_vpc_subnet.subnet.id
  managers      = 1
  workers       = 2
  ssh_credentials = {user = "ubuntu", private_key = ".ssh/weaveworksdemos.pri", pub_key = ".ssh/weaveworksdemos.pub"}
}
