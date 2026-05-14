terraform {
  required_providers {
    docker = {
      source  = "registry.terraform.io/kreuzwerker/docker" # Актуальный адрес провайдера в Registry
    }
  }
}

provider "docker" {} # Подключается к Docker-демону OrbStack автоматически

# 1. Веб-сервер Nginx
resource "docker_container" "nginx" {
  name  = "nginx-server"
  image = "nginx:latest"
  ports {
    internal = 80
    external = 8080
  }
  restart = "always"
}

# 2. База данных PostgreSQL
resource "docker_container" "postgres" {
  name  = "postgres-db"
  image = "postgres:latest"
  env = [
    "POSTGRES_USER=admin",
    "POSTGRES_PASSWORD=examplepassword",
    "POSTGRES_DB=app_db"
  ]
  ports {
    internal = 5432
    external = 5432
  }
  restart = "always"
}

# 3. Кэш-хранилище Redis
resource "docker_container" "redis" {
  name  = "redis-cache"
  image = "redis:latest"
  ports {
    internal = 6379
    external = 6379
  }
  restart = "always"
}

