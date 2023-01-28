terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

# ==== Droplet ====
resource "digitalocean_droplet" "jenkins" {
  image    = "ubuntu-22-04-x64"
  name     = "jenkins"
  region   = var.region
  size     = "s-2vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.ssh_key.id]
}

data "digitalocean_ssh_key" "ssh_key" {
  name = var.ssh_key_name
}

# ==== Kubernetes Cluster ====
resource "digitalocean_kubernetes_cluster" "k8s" {
  name   = "k8s"
  region = var.region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.25.4-do.0"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 2
  }
}

variable "region" {
  default = "nyc1"
}

variable "do_token" {
  default = ""
}

variable "ssh_key_name" {
  default = ""
}

output "jenkins_ip" {
  value = digitalocean_droplet.jenkins.ipv4_address
}

resource "local_file" "name" {
  content  = digitalocean_kubernetes_cluster.k8s.kube_config.0.raw_config
  filename = "${path.module}/kube_config.yaml"
}
