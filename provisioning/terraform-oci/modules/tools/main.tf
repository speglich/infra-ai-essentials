# This module install Docker and NVIDIA Container Toolkit on the instance

resource "null_resource" "docker_install" {
 count = var.setup_docker ? 1 : 0

  provisioner "remote-exec" {
    inline = [
      "sudo dnf -y install dnf-plugins-core",
      "sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo",
      "sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
      "sudo systemctl enable --now docker",
      "sudo groupadd docker",
      "sudo usermod -aG docker $USER"
    ]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
      host        = var.instance_public_ip
      timeout     = "5m"
    }
  }
}

resource "null_resource" "nvidia_container_toolkit_install" {
  depends_on = [ null_resource.docker_install ]
  count = var.setup_nvidia_container_toolkit ? 1 : 0

  provisioner "remote-exec" {
    inline = [
      "curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo",
      "sudo dnf-config-manager --enable nvidia-container-toolkit-experimental",
      "sudo dnf install -y nvidia-container-toolkit",
      "sudo nvidia-ctk runtime configure --runtime=docker",
      "sudo systemctl restart docker",
    ]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
      host        = var.instance_public_ip
      timeout     = "5m"
    }
  }
}

resource "null_resource" "llama_container" {
  depends_on = [ null_resource.nvidia_container_toolkit_install ]
  count = var.setup_llama ? 1 : 0

  provisioner "remote-exec" {
    inline = [
      "docker run --runtime nvidia --gpus all --name my_llama_container -v ~/.cache/huggingface:/root/.cache/huggingface --env \"HUGGING_FACE_HUB_TOKEN=${var.hugging_face_token}\" -p 8000:8000  --ipc=host -d vllm/vllm-openai:latest --model meta-llama/Llama-3.1-8B-Instruct"
    ]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
      host        = var.instance_public_ip
      timeout     = "5m"
    }
  }
}