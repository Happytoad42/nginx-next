# Простое приложение на NextJS, статику раздает NGINX, все внутри докер-контейнеров

## 1. Запуск при помощи docker-compose

Выполнить **docker-compose up**

Теперь можно пройти по адресу **http://localhost** (без порта, по дефолту торчит на 80 порте)

## 2. Запуск без docker-compose

### Соберем образы

docker build --tag nextjs-image .

docker build --tag nginx-image ./nginx

### Создадим общую сеть

docker network create my-network

### Запустим контейнеры

docker run --network my-network --name nextjs-container nextjs-image

docker run --network my-network --link nextjs-container:nextjs --publish 80:80 nginx-image

## Про кеширование

Статика закеширована, включая картинки из /static. Проверить можно, проинспектировав вкладку **Network** при запущенном приложении. В запросах к статике (например картинки) будет стоять заголовок **X-Cache-Status** в значении **MISS** если запрос НЕ кеширован (первый запрос) или **HIT**, если отдаются кешированные данные.

## Kubernetes

Настроен базовый деплой для использования с кубиком (пока только сам некст). Для использования необходимы minikube и kubectl (последий идет в пакете с minikube, отдельно устанавливать не нужно, если плнируется только локальная разработка)

### Запустим minikube

minikube start

### Создадим и развернем деплой, выставим наружу 3000 порт

kubectl create deployment nextjs-nginx-app --image=docker.io/amikhailov2gis/nextjs-k8s
kubectl expose deployment nextjs-nginx-app --type=NodePort --port=3000

### Проверим, что служба добавилась и работает

kubectl get svc

### Запустим наш сервис

minikube service nextjs-nginx-app --url

Полученный URL можно использовать для запуска приложения из кластера кубика.
