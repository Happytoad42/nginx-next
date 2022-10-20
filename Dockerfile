FROM node:alpine

# Укажем рабочую директорию
WORKDIR /usr/app

# Установим пакет PM2 (для автоматического рестарта, но вообще это пакетный менеджер для NodeJS)
RUN npm install --global pm2

# Сначала скопируем package.json и package-lock.json 
# Docker cache поможет избежать лишних переустановок зависимостей
COPY ./package*.json ./


# Установим зависимости
RUN npm install --production

# Скопируем остальные файлы
COPY ./ ./

# Сбилдимся
RUN npm run build

# Выставим наружу порт
EXPOSE 3000

# Запустим контейнер как не-привелигированный пользователь (иначе был бы root)
# Дефолтный юзер node идет вместе с пакетом alpine
USER node

# Запустим скрипт c PM2 после загрузки контейнера
# эта команда делает то же самое, что и "npm start", но под контролем PM2
CMD [ "pm2-runtime", "npm", "--", "start" ]