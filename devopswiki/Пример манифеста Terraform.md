

```
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


```


Описание шагов: 

1. Инициализация и обход блокировок (Строки 1–7)

```
terraform {              # Глобальный блок настроек для Terraform / OpenTofu
  required_providers {   # Секция декларации внешних плагинов, необходимых для манифеста
    docker = {           # Локальное имя провайдера, которое используется ниже в коде
      source  = "registry.terraform.io/kreuzwerker/docker" 
      # ^ Официальный адрес современного плагина. Префикс registry.terraform.io 
      # позволяет перехватить этот запрос вашим файлом ~/.terraformrc 
      # и скачать плагин напрямую с зеркала Yandex Cloud без VPN.
    }
  }
}

```

2. Настройка подключения к среде исполнения (Строка 9)

```
provider "docker" {} # Активация провайдера. Пустые скобки запускают дефолтный механизм поиска сокета

```

3. Локальный веб-сервер Nginx (Строки 11–22)

```
# 1. Веб-сервер Nginx
resource "docker_container" "nginx" { # Объявление ресурса: тип "docker_container", имя в коде "nginx"
  name  = "nginx-server"              # Физическое имя контейнера в CLI Docker (параметр --name)
  image = "nginx:latest"              # Образ, который будет автоматически скачан с Docker Hub
  ports {                             # Маппинг сетевых портов (параметр -p)
    internal = 80                     # Внутренний порт, на котором работает Nginx внутри контейнера
    external = 8080                   # Внешний порт вашего Mac. Делает сайт доступным по адресу http://localhost:8080
  }
  restart = "always"                  # Политика перезапуска: контейнер поднимется сам при перезапуске OrbStack или сбое
}

```

4. Изолированная СУБД PostgreSQL (Строки 24–40)

```
# 2. База данных PostgreSQL
resource "docker_container" "postgres" { # Объявление ресурса контейнера с именем в коде "postgres"
  name  = "postgres-db"                  # Имя, под которым контейнер отображается в списке `docker ps`
  image = "postgres:latest"              # Использование актуального официального образа PostgreSQL
  env = [                                # Массив переменных окружения для первичной настройки БД (параметр -e)
    "POSTGRES_USER=admin",               # Создание администратора базы данных с логином "admin"
    "POSTGRES_PASSWORD=examplepassword", # Установка пароля для созданного пользователя
    "POSTGRES_DB=app_db"                 # Автоматическое создание целевой базы данных с именем "app_db"
  ]
  ports {                                # Настройка сети для БД
    internal = 5432                      # Стандартный внутренний порт СУБД PostgreSQL
    external = 5432                      # Внешний порт на вашем Макбуке для подключения IDE или приложений
  }
  restart = "always"                     # Автоматический перезапуск контейнера при непредвиденном падении процесса
}

```

5. Кэш-хранилище в оперативной памяти Redis (Строки 42–51)

```
# 3. Кэш-хранилище Redis
resource "docker_container" "redis" { # Объявление последнего ресурса с именем в коде "redis"
  name  = "redis-cache"               # Название контейнера в вашей локальной песочнице
  image = "redis:latest"              # Загрузка и старт официального образа NoSQL базы данных Redis
  ports {                             # Конфигурация портов для кэша
    internal = 6379                   # Стандартный рабочий порт Redis-сервера внутри контейнера
    external = 6379                   # Порт вашего Mac, на который мы отправляли проверочную команду `ping`
  }
  restart = "always"                  # Обеспечивает постоянную работу сервиса в фоновом режиме
}

```