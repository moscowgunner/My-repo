# Kubernetes Troubleshooting: `kubectl connection refused`

## Симптом

```bash
kubectl get nodes
```

Ошибка:

```text
The connection to the server 0.0.0.0:XXXXX was refused
```

---

# Алгоритм диагностики

## 1. Проверить Docker

```bash
docker ps
```

Если появляется ошибка:

```text
Cannot connect to the Docker daemon
```

значит проблема не в Kubernetes, а в Docker (Docker Desktop, OrbStack и т.д.).

---

## 2. Проверить, существует ли кластер

```bash
k3d cluster list
```

Например:

```text
NAME      SERVERS   AGENTS
sandbox   1/1       2/2
```

Это означает, что кластер зарегистрирован в k3d.

---

## 3. Проверить, что контейнеры действительно запущены

```bash
docker ps
```

Ожидаемый вывод:

```text
k3d-sandbox-server-0
k3d-sandbox-agent-0
k3d-sandbox-agent-1
k3d-sandbox-serverlb
```

Если `server-0` отсутствует или имеет статус `Exited`, API Server работать не будет.

---

## 4. Проверить, на какой порт проброшен Kubernetes API

```bash
docker ps
```

Например:

```text
0.0.0.0:61334->6443/tcp
```

Это означает:

```text
localhost:61334
        │
        ▼
6443 внутри контейнера Kubernetes
```

---

## 5. Проверить kubeconfig

```bash
kubectl config view --minify
```

Ищем поле:

```yaml
server:
```

Например:

```yaml
server: https://0.0.0.0:50245
```

Если порт отличается от порта в `docker ps`, значит `kubectl` использует устаревший kubeconfig.

---

## 6. Проверить kubeconfig, который хранит k3d

```bash
k3d kubeconfig get sandbox
```

Например:

```yaml
server: https://0.0.0.0:61334
```

Если здесь порт правильный, а в `kubectl config view` — старый, значит проблема именно в kubeconfig.

---

## 7. Обновить kubeconfig

```bash
k3d kubeconfig write sandbox
```

или вручную заменить:

```bash
cp ~/.config/k3d/kubeconfig-sandbox.yaml ~/.kube/config
```

После этого проверить:

```bash
kubectl get nodes
```

---

# Полезные команды

```bash
docker ps
docker info

k3d cluster list
k3d node list
k3d kubeconfig get sandbox

kubectl config view --minify
kubectl config current-context
kubectl cluster-info
kubectl get nodes
```

---

# Как работает цепочка

```text
kubectl
    │
    ▼
~/.kube/config
    │
    ▼
server=https://0.0.0.0:61334
    │
    ▼
Docker Port Mapping
61334 ─────────────► 6443
    │
    ▼
k3d-sandbox-server-0
    │
    ▼
kube-apiserver
    │
    ▼
etcd
```

---

# Главное правило

При ошибке `connection refused` всегда проверять в таком порядке:

1. Работает ли Docker?
    
2. Запущен ли кластер?
    
3. Совпадает ли порт API Server с портом в kubeconfig?
    
4. Отвечает ли API Server?
    

В большинстве случаев проблема находится на одном из этих четырех шагов.