FROM nginx:alpine

# Почистим имеющийся конфиг
RUN rm /etc/nginx/conf.d/*

# Скопируем конфиг
# *.conf файлы в директории conf.d/ нужно включить в основной конфиг
COPY ./default.conf /etc/nginx/conf.d/

# Выставим наруж порт
EXPOSE 80

#  Запустим nginx
CMD [ "nginx", "-g", "daemon off;" ]