# Hello World Go Application for k3s

Минимальная конфигурация для развертывания Go приложения на k3s.

## Структура проекта

- `main.go` - простое HTTP сервер приложение
- `Dockerfile` - многоступенчатая сборка Docker образа
- `k8s/deployment.yaml` - Kubernetes Deployment
- `k8s/service.yaml` - Kubernetes Service

## Развертывание

### 1. Сборка Docker образа

```bash
docker build -t hello-world:latest .
```

### 2. Загрузка образа в k3s

Если используете локальный k3s:

```bash
# Копирование образа в k3s
docker save hello-world:latest | sudo k3s ctr images import -
```

Или используйте локальный registry или загрузите в Docker Hub.

### 3. Применение манифестов

```bash
kubectl apply -f k8s/
```

### 4. Проверка статуса

```bash
kubectl get pods
kubectl get svc
```

### 5. Тестирование

```bash
# Port-forward для локального доступа
kubectl port-forward svc/hello-world 8080:80

# В другом терминале
curl http://localhost:8080
```

## Альтернативный вариант с использованием Docker Hub

Если образ загружен в Docker Hub:

1. Обновите `image` в `k8s/deployment.yaml` на ваш Docker Hub путь
2. Установите `imagePullPolicy: Always` или уберите `imagePullPolicy: IfNotPresent`

