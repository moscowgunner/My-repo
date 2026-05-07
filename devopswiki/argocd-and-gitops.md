# 🐙 Автоматизация деплоя (ArgoCD & GitOps)

## 🔐 Управление доступом
Вытащить автоматически сгенерированный пароль администратора:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

## 🌉 Сетевой мост (Port-Forward)
Открыть доступ к веб-интерфейсу ArgoCD с локального Мака (не закрывать этот терминал!):
```bash
kubectl port-forward svc/argocd-server -n argocd 8443:443
```
*Адрес для открытия в Safari:* `https://localhost:8443` (Логин: `admin`)

## 🛠️ Первичный деплой (Server-Side)
Установить ArgoCD в чистый кластер, обходя лимиты клиентского apply и конфликты полей:
```bash
kubectl create namespace argocd
kubectl apply --server-side --force-conflicts -n argocd -f https://githubusercontent.com
```

## 🔄 Скорая помощь при ошибке ImagePullBackOff (Российское зеркало)
Заменить капризный или заблокированный Docker-образ Redis на зеркало от Яндекса без пересоздания ArgoCD:
```bash
kubectl set image deployment/argocd-redis redis=cr.yandex/mirror/library/redis:7.2.4-alpine -n argocd
```
