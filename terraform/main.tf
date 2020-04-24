resource "google_compute_instance" "master" {
  name = "master-1"
  machine_type = "${var.machine_type}"
  zone = "${"${var.region}"}-a"


  boot_disk {
      initialize_params {
          image = "${var.image}"
          size = "20"
      }
  }

  network_interface {
      network = "default"

      access_config { 
          // Ephemeral IP
      }
  }

  service_account {
      scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  metadata = {
    ssh-keys = "${var.username}:${file("${var.path}/gcp_compute_key.pub")}"
    }
  
  provisioner "remote-exec" {
      inline = [
          "sudo sed -ie 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config",
          "sudo systemctl restart sshd"
      ]
      connection {
          host        = self.network_interface[0].access_config[0].nat_ip
          type = "ssh"
          user = "${var.username}"
          private_key = "${file("${var.path}/gcp_compute_key")}"
          agent =   true
      }
  }
}

resource "google_compute_disk" "master" {
    name = "mdocker"
    type = "pd-ssd"
    zone = "${"${var.region}"}-a"
    size = "10"
}

resource "google_compute_attached_disk" "master" {
    disk = "${google_compute_disk.master.self_link}"
    instance = "${google_compute_instance.master.self_link}"
}

resource "google_compute_instance" "bootstrap" {
  name = "bootstrap"
  machine_type = "${var.machine_type}"
  zone = "${"${var.region}"}-a"


  boot_disk {
      initialize_params {
          image = "${var.image}"
          size = "20"
      }
  }

  network_interface {
      network = "default"

      access_config { 
          // Ephemeral IP
      }
  }

  service_account {
      scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  metadata = {
    ssh-keys = "${var.username}:${file("${var.path}/gcp_compute_key.pub")}"
  }

  

  provisioner "remote-exec" {
      inline = [
          "sudo sed -ie 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config",
          "sudo systemctl restart sshd"
      ]
      connection {
          host        = self.network_interface[0].access_config[0].nat_ip
          type = "ssh"
          user = "${var.username}"
          private_key = "${file("${var.path}/gcp_compute_key")}"
          agent =   true
      }
  }
}

resource "google_compute_disk" "bootstrap" {
    name = "idocker"
    type = "pd-ssd"
    zone = "${"${var.region}"}-a"
    size = "10"
}

resource "google_compute_attached_disk" "bootstrap" {
    disk = "${google_compute_disk.bootstrap.self_link}"
    instance = "${google_compute_instance.bootstrap.self_link}"
}

resource "google_compute_instance" "worker" {
  name = "worker-1"
  machine_type = "${var.machine_type}"
  zone = "${"${var.region}"}-a"


  boot_disk {
      initialize_params {
          image = "${var.image}"
          size = "20"
      }
  }

  network_interface {
      network = "default"

      access_config { 
          // Ephemeral IP
      }
  }

  service_account {
      scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  metadata = {
    ssh-keys = "${var.username}:${file("${var.path}/gcp_compute_key.pub")}"
  }

  provisioner "remote-exec" {
      inline = [
          "sudo sed -ie 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config",
          "sudo systemctl restart sshd"
      ]
      connection {
          host        = self.network_interface[0].access_config[0].nat_ip
          type = "ssh"
          user = "${var.username}"
          private_key = "${file("${var.path}/gcp_compute_key")}"
          agent =   true
      }
  }
}

resource "google_compute_disk" "worker" {
    name = "wdocker"
    type = "pd-ssd"
    zone = "${"${var.region}"}-a"
    size = "10"
}

resource "google_compute_attached_disk" "worker" {
    disk = "${google_compute_disk.worker.self_link}"
    instance = "${google_compute_instance.worker.self_link}"
}

# resource "google_compute_instance" "svcnode" {
#   name = "svcnode"
#   machine_type = "${var.machine_type}"
#   zone = "${"${var.region}"}-a"


#   boot_disk {
#       initialize_params {
#           image = "centos-cloud/centos-8"
#           size = "20"
#       }
#   }

#   network_interface {
#       network = "default"

#       access_config { 
#           // Ephemeral IP
#       }
#   }

#   service_account {
#       scopes = ["userinfo-email", "compute-ro", "storage-ro"]
#   }

#   metadata = {
#     ssh-keys = "${var.username}:${file("${var.path}/gcp_compute_key.pub")}"
#   }
#   provisioner "remote-exec" {
#       inline = [
#           "sudo sed -ie 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config",
#           "sudo systemctl restart sshd"
#       ]
#       connection {
#           host        = self.network_interface[0].access_config[0].nat_ip
#           type = "ssh"
#           user = "${var.username}"
#           private_key = "${file("${var.path}/gcp_compute_key")}"
#           agent =   true
#       }
#   }
# }

# resource "google_compute_disk" "svcnode" {
#     name = "svcnode1"
#     type = "pd-ssd"
#     zone = "${"${var.region}"}-a"
#     size = "100"
# }

# resource "google_compute_attached_disk" "svcnode" {
#     disk = "${google_compute_disk.svcnode.self_link}"
#     instance = "${google_compute_instance.svcnode.self_link}"
}