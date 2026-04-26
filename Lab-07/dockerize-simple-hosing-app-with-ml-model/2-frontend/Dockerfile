FROM nginx:1.29.0
EXPOSE 80
COPY ./src/ /usr/share/nginx/html/
COPY ./nginx.template.conf /etc/nginx/templates/default.conf.template
ENV API_URL=http://192.168.65.91:5000

