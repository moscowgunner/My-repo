# Docker — основные команды

## Проверка установки

```bash
docker --version
docker info
```

## Работа с образами

### Скачать образ

```bash
docker pull nginx
docker pull postgres:16
```

### Список образов

```bash
docker images
```

### Удалить образ

```bash
docker rmi nginx
docker rmi IMAGE_ID
```

### Сборка собственного образа

```bash
docker build -t my-app .
docker build -t my-app:v1 .
```

---

## Работа с контейнерами

### Запустить контейнер

```bash
docker run nginx
```

### Запустить в фоне

```bash
docker run -d nginx
```

### Задать имя

```bash
docker run -d --name web nginx
```

### Пробросить порт

```bash
docker run -d -p 8080:80 nginx
```

### Передать переменные окружения

```bash
docker run -e DB_USER=admin postgres
```

### Смонтировать папку

```bash
docker run -v $(pwd):/app ubuntu
```

---

## Просмотр контейнеров

### Запущенные

```bash
docker ps
```

### Все контейнеры

```bash
docker ps -a
```

---

## Управление контейнерами

### Остановить

```bash
docker stop CONTAINER
```

### Запустить

```bash
docker start CONTAINER
```

### Перезапустить

```bash
docker restart CONTAINER
```

### Удалить

```bash
docker rm CONTAINER
```

### Удалить принудительно

```bash
docker rm -f CONTAINER
```

---

## Логи

### Просмотр логов

```bash
docker logs CONTAINER
```

### Следить за логами

```bash
docker logs -f CONTAINER
```

### Последние строки

```bash
docker logs --tail 100 CONTAINER
```

---

## Подключение внутрь контейнера

### Bash

```bash
docker exec -it CONTAINER bash
```

### Sh

```bash
docker exec -it CONTAINER sh
```

---

## Информация

### Детальная информация

```bash
docker inspect CONTAINER
```

### Использование ресурсов

```bash
docker stats
```

---

## Очистка

### Удалить остановленные контейнеры

```bash
docker container prune
```

### Удалить неиспользуемые образы

```bash
docker image prune -a
```

### Полная очистка

```bash
docker system prune -a
```

---

## Полезные команды

### Список сетей

```bash
docker network ls
```

### Список томов

```bash
docker volume ls
```

### Копирование файлов

```bash
docker cp file.txt CONTAINER:/tmp
docker cp CONTAINER:/tmp/file.txt .
```