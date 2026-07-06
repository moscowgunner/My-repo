## 🧠 Зачем это нужно

`kubectx` и правильная работа с `KUBECONFIG` помогают:

- быстро переключаться между Kubernetes-кластерами
- не путаться в `~/.kube/config`
- изолировать локальные (k3d/kind/minikube) и облачные (EKS/GKE/AKS) кластеры
- избегать ошибок типа `connection refused` из-за старых портов

---

# ⚙️ kubectx — переключение контекстов

## 📦 Установка

```
brew install kubectx
```

---

## 🔍 Посмотреть доступные контексты

```
kubectx
```

Пример вывода:

```
k3d-sandboxk3d-labeks-deveks-prodminikube
```

---

## 🔄 Переключить контекст

```
kubectx k3d-sandbox
```

👉 Это просто делает:

```
kubectl config use-context k3d-sandbox
```

---

## 📌 Проверить текущий контекст

```
kubectl config current-context
```

---

# 📁 kubeconfig — как работать правильно

## 🧠 Важно понимать

`kubectx` НЕ управляет портами и конфигами — он только переключает контекст.

Настоящая конфигурация хранится в kubeconfig:

```
~/.kube/config
```

---

# 🧩 Лучший подход: отдельные kubeconfig файлы

## 📂 Рекомендуемая структура

```
~/.kube/
├── k3d/
│   ├── sandbox.yaml
│   ├── lab.yaml
│   └── test.yaml
├── cloud/
│   ├── eks-dev.yaml
│   └── eks-prod.yaml
```

---

## 📥 Создать kubeconfig для k3d

```
k3d kubeconfig get sandbox > ~/.kube/k3d/sandbox.yaml
```

или более правильно:

```
k3d kubeconfig write sandbox
```

---

# 🔁 Переключение через KUBECONFIG

## 📌 Активировать кластер

```
export KUBECONFIG=~/.kube/k3d/sandbox.yaml
kubectl get nodes
```

---

## ⚡ Быстрое переключение (алиасы)

Добавь в `~/.zshrc`:

```
alias ksandbox='export KUBECONFIG=~/.kube/k3d/sandbox.yaml'alias klab='export KUBECONFIG=~/.kube/k3d/lab.yaml'
```

Использование:

```
ksandboxkubectl get nodes
```

---

# 🧠 Альтернатива: несколько kubeconfig одновременно

```
export KUBECONFIG=~/.kube/k3d/sandbox.yaml:~/.kube/cloud/eks.yaml
```

Потом:

```
kubectl config get-contextskubectl config use-context eks-prod
```

---

# ⚠️ Частые проблемы

## ❌ connection refused

Причина:

- kubeconfig указывает на старый порт k3d
- кластер пересоздан

Проверка:

```
kubectl config view --minifydocker ps | grep k3d
```

---

## ❌ kubectx переключил, но kubectl не работает

Причина:

- kubeconfig содержит устаревший server URL

Решение:

```
k3d kubeconfig write <cluster>
```

---

# 🚀 Рекомендуемый workflow

## Для локальных кластеров (k3d)

```
k3d kubeconfig write sandbox
export KUBECONFIG=~/.config/k3d/kubeconfig-sandbox.yaml
kubectx k3d-sandbox
kubectl get nodes
```

---

## Главное правило

> kubectx переключает контекст  
> kubeconfig определяет, КУДА реально идёт kubectl

---

# 🧩 Ментальная модель

```
kubectx
  ↓
выбор контекста

kubeconfig
  ↓
реальный API server (IP:PORT)

kubectl
  ↓
запрос в Kubernetes API
```