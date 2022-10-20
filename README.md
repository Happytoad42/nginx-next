# Простое приложение на NextJS, статику раздает NGINX, все внутри докер-контейнеров

## Как запустить

### 1. При помощи docker-compose

Выполнить docker-compose up

Теперь можно пройти по адресу http://localhost (без порта, по дефолту торчит на 80 порте)

### 2. Без docker-compose

**Соберем образы**
docker build --tag nextjs-image .
docker build --tag nginx-image ./nginx

**Создадим общую сеть**
docker network create my-network

**Запустим контейнеры**
docker run --network my-network --name nextjs-container nextjs-image
docker run --network my-network --link nextjs-container:nextjs --publish 80:80 nginx-image

## Про кеширование

Статика закеширована, включая картинки из /static. Проверить можно, проинспектировав вкладку **Network** при запущенном приложении. В запросах к статике (например картинки) будет стоять заголовок **X-Cache-Status** в значении **MISS** если запрос НЕ кеширован (первый запрос) или **HIT**, если отдаются кешированные данные.
