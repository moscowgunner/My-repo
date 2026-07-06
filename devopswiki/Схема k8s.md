
# 🧠 Kubernetes Architecture (полная схема)

## 🧩 1. Общая структура кластера

```
Kubernetes Cluster
│
├── Control Plane (Master Nodes)
│   ├── kube-apiserver
│   ├── etcd
│   ├── kube-scheduler
│   ├── kube-controller-manager
│   └── cloud-controller-manager (optional)
│
└── Worker Nodes
    ├── kubelet
    ├── kube-proxy
    ├── container runtime (containerd / CRI-O / docker legacy)
    └── Pods
```

---

## 🎯 2. Control Plane — “мозг кластера”

### 🔌 kube-apiserver

```
- Единственная точка входа в кластер
- Принимает все команды (kubectl, UI, controllers)
- Валидирует запросы
- Записывает/читает состояние из etcd
```

👉 Это “фронт-дверь” Kubernetes

---

### 🗄 etcd

```
- Распределённая key-value база данных
- Хранит ВСЁ состояние кластера:
  - Pods
  - Deployments
  - ConfigMaps
  - Secrets
  - Nodes state
```

👉 Это “память” Kubernetes

---

### 🧠 kube-scheduler

```
- Решает, на какой ноде запустить Pod  
- НЕ запускает Pod  
- Только принимает решение  
  
Факторы:  
- CPU / RAM  
- taints / tolerations  
- affinity / anti-affinity  
- ресурсы нод
```

👉 Это “логист”

---

### 🔁 kube-controller-manager

```
- Следит за тем, чтобы кластер совпадал с желаемым состоянием

Внутри него контроллеры:
  - ReplicaSet controller
  - Deployment controller
  - Node controller
  - Job controller
  - Endpoint controller
```

👉 Это “автопилот / система самовосстановления”

---

### ☁ cloud-controller-manager (если облако)

```
- Интеграция с облаком (AWS/GCP/Azure)
- Управляет:
  - Load Balancers
  - Volumes
  - Nodes lifecycle
```

---

## 🧱 3. Worker Node — “исполнители”

### ⚙️ kubelet

```
- Агент на каждой ноде
- Получает инструкции от API Server
- Запускает и следит за Pod’ами
- Репортит статус обратно
```

👉 “менеджер локального выполнения”

---

### 🌐 kube-proxy

```
- Управляет сетевыми правилами
- Делает Service → Pod routing
- Работает через iptables / IPVS
```

👉 “сетевой маршрутизатор внутри кластера”

---

### 📦 Container Runtime

```
- containerd / CRI-O
- запускает контейнеры
- скачивает образы
```

👉 “движок контейнеров”

---

## 📦 4. Pod Layer (самое нижнее)

```
Pod
├── 1+ containers
├── shared network namespace
├── shared volumes
└── ephemeral lifecycle
```

👉 Это минимальная единица запуска в Kubernetes

---

## 🔄 5. Полный поток

```
1. kubectl apply deployment.yaml
        ↓
2. kube-apiserver принимает запрос
        ↓
3. etcd сохраняет desired state
        ↓
4. kube-controller-manager:
       - создаёт ReplicaSet
       - создаёт Pods
        ↓
5. kube-scheduler:
       - выбирает ноды для Pods
        ↓
6. kubelet на нодах:
       - запускает контейнеры
        ↓
7. kube-proxy:
       - настраивает сеть
        ↓
8. cluster работает
```

---

## 🧠 6. Ментальная модель

```
API Server = входная дверь
etcd = память
Scheduler = распределитель задач
Controller Manager = автопилот (чинит всё)
Kubelet = исполнитель на машине
Kube-proxy = сетевой маршрутизатор
Container Runtime = двигатель контейнеров
```

---

## 🔥 7. Ключевая идея Kubernetes

> Kubernetes — это не система запуска контейнеров  
> это система, которая постоянно приводит реальность к желаемому состоянию