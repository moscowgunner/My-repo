# 🛠️ Особенности интеграции Ansible с легковесными машинами OrbStack (macOS)

### 🚨 Проблема: Ошибки SSH и `Failed to create temporary directory`
При попытке запустить стандартный плейбук через сетевые коннекторы (`ssh` или `docker`) на macOS внутри машин OrbStack возникают ошибки прав доступа. Это происходит потому, что Ansible пытается генерировать временные скрипты автоматизации в директориях `${USER}` или `/tmp`, которые жестко изолированы архитектурой контейнеров.

### 💡 Решение: Нативный CLI-коннектор (Подход Local Exec)
Вместо борьбы с конфигурациями путей и генерацией SSH-ключей для root-пользователя, самым надежным и быстрым DevOps-решением является запуск плейбука локально (`ansible_connection=local`) с пробросом команд через встроенную утилиту `orb exec`.

## 📁 1. Конфигурация инвентаря (`inventory.ini`)
Указываем локальное выполнение на хосте разработки (Mac):
```ini
[webservers]
localhost ansible_connection=local
```

## 📜 2. Шаблон отказоустойчивого плейбука
Используем модуль `shell` для выполнения команд внутри конкретной машины от имени root через правильные флаги (`-m <имя_машины> -u root`).

```yaml
---
- name: Установка и настройка apache внутри OrbStack
  hosts: webservers
  tasks:
    - name: Обновление apt кэша и установка Apache
      shell: |
        orb exec -m ubuntu -u root apt-get update
        orb exec -m ubuntu -u root apt-get install -y apache2
      when: not (cleanup_apache | default(false) | bool)

    - name: Запуск веб-сервера Apache
      shell: orb exec -m ubuntu -u root systemctl start apache2
      when: not (cleanup_apache | default(false) | bool)

- name: Завершение работы apache (cleanup)
  hosts: webservers
  tasks:
    - name: Остановка и полное удаление веб-сервера
      shell: |
        orb exec -m ubuntu -u root systemctl stop apache2
        orb exec -m ubuntu -u root apt-get purge -y apache2
        orb exec -m ubuntu -u root apt-get autoremove -y
      when: cleanup_apache | default(false) | bool
```

## 🚀 3. Шпаргалка по командам запуска

1. **Запуск сценария на установку пакетов:**
   ```bash
   ansible-playbook -i inventory.ini manage-apache-playbook.yml
   ```

2. **Запуск сценария на удаление (Cleanup):**
   *Важно:* Чтобы избежать ошибки `derived from value of type 'str'`, передаем переменную строго в формате JSON, а внутри кода обязательно используем фильтр `| bool`. Для скрытия предупреждений интерпретатора Python добавляем переменную тишины.
   ```bash
   ANSIBLE_INTERPRETER_PYTHON=auto_silent ansible-playbook -i inventory.ini manage-apache-playbook.yml --extra-vars '{"cleanup_apache": true}'
   ```

Пример обычного плейбука без танцев с контейнерами:

```
- name: установка и настройка apache
hosts: webservers
become: yes
tasks:
    - name: обновление apt кэша
       apt:
            update_cache: yes
            cache_valid_time: 3600
    - name: установка apache

       apt:
            name: apache2
            state: present
- name: запуск и включение apache
   service:
       name: apache2
       state: started
       enabled: yes
```



# 🐳 Автоматизация деплоя Docker на полноценный Linux-сервер по SSH

Этот плейбук устанавливает Docker на дистрибутивы Ubuntu (включая архитектуры ARM64 / Apple Silicon) из стабильных репозиториев и настраивает конфигурацию зеркал для бесперебойного скачивания образов.

## 📂 1. Файл инвентаря (`inventory.ini`)
Указываем параметры авторизации на удаленном сервере:
```ini
[webservers]
192.168.139.153 ansible_user=vladislav ansible_password=12345 ansible_sudo_pass=12345
```

## 📜 2. Текст плейбука (`install-docker-playbook.yml`)
```yaml
---
- name: Установка и настройка Docker на полноценном Linux-сервере
  hosts: webservers
  become: yes
  tasks:
    - name: Установка компонентов Docker и системных зависимостей
      apt:
        name:
          - apt-transport-https
          - ca-certificates
          - curl
          - software-properties-common
          - gnupg
          - docker.io
        state: present
        update_cache: yes

    - name: Настройка daemon.json для обхода блокировок Docker Hub (Зеркала Registry)
      copy:
        dest: "/etc/docker/daemon.json"
        content: |
          {
              "registry-mirrors": [
                  "https://gcr.io",
                  "https://cr.yandex",
                  "https://docker-cn.com",
                  "aliyuncs.com"
              ]
          }
        mode: "0644"

    - name: Перезапуск и включение службы Docker через Systemd
      service:
        name: docker
        state: restarted
        enabled: yes
```

## 🚀 3. Команда запуска
```bash
ANSIBLE_INTERPRETER_PYTHON=auto_silent ansible-playbook -i inventory.ini install-docker-playbook.yml
```
