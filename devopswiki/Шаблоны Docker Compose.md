# Docker Compose — шаблоны docker-compose.yml

## Минимальный шаблон

```yaml
services:
  app:
    image: nginx:latest
    ports:
      - "8080:80"
```

Запуск:

```bash
docker compose up -d
```

---

# Nginx

```yaml
services:
  nginx:
    image: nginx:latest
    container_name: nginx
    restart: unless-stopped

    ports:
      - "80:80"

    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./html:/usr/share/nginx/html:ro
```

---

# PostgreSQL

```yaml
services:
  postgres:
    image: postgres:16

    container_name: postgres

    restart: unless-stopped

    environment:
      POSTGRES_DB: app_db
      POSTGRES_USER: app_user
      POSTGRES_PASSWORD: secret_password

    ports:
      - "5432:5432"

    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

Подключение:

```bash
Host: localhost
Port: 5432
User: app_user
Password: secret_password
Database: app_db
```

---

# Redis

```yaml
services:
  redis:
    image: redis:7

    container_name: redis

    restart: unless-stopped

    ports:
      - "6379:6379"

    volumes:
      - redis_data:/data

volumes:
  redis_data:
```

---

# PostgreSQL + pgAdmin

```yaml
services:
  postgres:
    image: postgres:16

    environment:
      POSTGRES_DB: app_db
      POSTGRES_USER: app_user
      POSTGRES_PASSWORD: secret

    volumes:
      - postgres_data:/var/lib/postgresql/data

  pgadmin:
    image: dpage/pgadmin4

    ports:
      - "5050:80"

    environment:
      PGADMIN_DEFAULT_EMAIL: admin@example.com
      PGADMIN_DEFAULT_PASSWORD: admin

    depends_on:
      - postgres

volumes:
  postgres_data:
```

Открыть:

```text
http://localhost:5050
```

---

# Node.js приложение

Структура:

```text
project/
├── Dockerfile
├── package.json
└── docker-compose.yml
```

docker-compose.yml:

```yaml
services:
  app:
    build: .

    ports:
      - "3000:3000"

    environment:
      NODE_ENV: production

    restart: unless-stopped
```

Dockerfile:

```dockerfile
FROM node:22-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
```

---

# Python FastAPI

docker-compose.yml:

```yaml
services:
  api:
    build: .

    ports:
      - "8000:8000"

    restart: unless-stopped
```

Dockerfile:

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

CMD [
  "uvicorn",
  "main:app",
  "--host",
  "0.0.0.0",
  "--port",
  "8000"
]
```

---

# Django + PostgreSQL

```yaml
services:
  db:
    image: postgres:16

    environment:
      POSTGRES_DB: django
      POSTGRES_USER: django
      POSTGRES_PASSWORD: secret

    volumes:
      - postgres_data:/var/lib/postgresql/data

  web:
    build: .

    ports:
      - "8000:8000"

    environment:
      DB_HOST: db
      DB_NAME: django
      DB_USER: django
      DB_PASSWORD: secret

    depends_on:
      - db

volumes:
  postgres_data:
```

---

# Laravel + MySQL

```yaml
services:
  app:
    build: .

    ports:
      - "8000:8000"

    depends_on:
      - mysql

  mysql:
    image: mysql:8.4

    environment:
      MYSQL_DATABASE: app
      MYSQL_USER: app
      MYSQL_PASSWORD: secret
      MYSQL_ROOT_PASSWORD: root

    volumes:
      - mysql_data:/var/lib/mysql

volumes:
  mysql_data:
```

---

# MongoDB

```yaml
services:
  mongo:
    image: mongo:8

    ports:
      - "27017:27017"

    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: secret

    volumes:
      - mongo_data:/data/db

volumes:
  mongo_data:
```

---

# Полезные директивы

## restart

Автоматический перезапуск контейнера:

```yaml
restart: unless-stopped
```

Варианты:

```yaml
restart: no
restart: always
restart: on-failure
restart: unless-stopped
```

---

## depends_on

Запускать после другого сервиса:

```yaml
depends_on:
  - postgres
```

---

## environment

Переменные окружения:

```yaml
environment:
  APP_ENV: production
  APP_DEBUG: false
```

Или:

```yaml
environment:
  - APP_ENV=production
  - APP_DEBUG=false
```

---

## ports

Проброс портов:

```yaml
ports:
  - "8080:80"
```

Формат:

```text
HOST:CONTAINER
```

---

## volumes

Монтирование файлов:

```yaml
volumes:
  - ./app:/app
```

Именованный том:

```yaml
volumes:
  - postgres_data:/var/lib/postgresql/data
```

---

## networks

Своя сеть:

```yaml
services:
  app:
    networks:
      - backend

  postgres:
    networks:
      - backend

networks:
  backend:
```

---

# Самый популярный production-стек

```yaml
services:
  nginx:
    image: nginx:latest

  app:
    build: .

  postgres:
    image: postgres:16

  redis:
    image: redis:7
```

Схема:

```text
Internet
    │
    ▼
 Nginx
    │
    ▼
 App
 ├── PostgreSQL
 └── Redis
```

---

# Полезный workflow

Создать:

```bash
docker compose up -d --build
```

Проверить:

```bash
docker compose ps
```

Логи:

```bash
docker compose logs -f
```

Зайти внутрь:

```bash
docker compose exec app bash
```

Перезапустить:

```bash
docker compose restart
```

Пересоздать:

```bash
docker compose down
docker compose up -d --build
```