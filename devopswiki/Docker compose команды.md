# Docker Compose — основные команды

## Запуск проекта

### Запустить все сервисы

```bash
docker compose up
```

### Запустить в фоне

```bash
docker compose up -d
```

### Пересобрать контейнеры

```bash
docker compose up --build
```

### Пересобрать и запустить

```bash
docker compose up -d --build
```

---

## Остановка

### Остановить сервисы

```bash
docker compose stop
```

### Остановить и удалить контейнеры

```bash
docker compose down
```

### Удалить тома

```bash
docker compose down -v
```

### Удалить образы

```bash
docker compose down --rmi all
```

---

## Логи

### Все логи

```bash
docker compose logs
```

### Следить за логами

```bash
docker compose logs -f
```

### Логи конкретного сервиса

```bash
docker compose logs nginx
```

---

## Работа с сервисами

### Список контейнеров

```bash
docker compose ps
```

### Перезапуск сервиса

```bash
docker compose restart nginx
```

### Остановить сервис

```bash
docker compose stop nginx
```

### Запустить сервис

```bash
docker compose start nginx
```

---

## Выполнение команд

### Войти в контейнер

```bash
docker compose exec nginx bash
```

### Выполнить команду

```bash
docker compose exec nginx ls -la
```

### Одноразовый запуск

```bash
docker compose run app python manage.py migrate
```

---

## Масштабирование

### Несколько экземпляров сервиса

```bash
docker compose up --scale app=3
```

---

## Проверка конфигурации

### Валидировать compose-файл

```bash
docker compose config
```

### Посмотреть итоговую конфигурацию

```bash
docker compose config --services
```

---

## Полезные команды

### Скачать образы

```bash
docker compose pull
```

### Собрать образы

```bash
docker compose build
```

### Скачать и запустить

```bash
docker compose pull && docker compose up -d
```

---

## Часто используемый набор

### Первый запуск

```bash
docker compose up -d --build
```

### Проверить контейнеры

```bash
docker compose ps
```

### Посмотреть логи

```bash
docker compose logs -f
```

### Перезапустить после изменений

```bash
docker compose restart
```

### Полностью пересоздать

```bash
docker compose down
docker compose up -d --build
```