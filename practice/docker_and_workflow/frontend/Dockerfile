FROM node:22-alpine AS build
WORKDIR /app
COPY ./package*.json .
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL
RUN npm install
COPY . .
RUN npm run build


FROM ubuntu/apache2
WORKDIR /app
RUN rm -rf /var/www/html/*
COPY --from=build /app/dist/ /var/www/html/
EXPOSE 80

