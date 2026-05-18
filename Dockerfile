# ETAPA 1: Construcción (Builder) usando Node
FROM node:18-alpine AS builder
WORKDIR /app

# Optimización de capas: copiamos solo los package.json primero
COPY package*.json ./
RUN npm install

# Copiamos el resto del código y construimos la aplicación
COPY . .
RUN npm run build

# ETAPA 2: Ejecución (Runtime) usando Nginx sin root
FROM nginxinc/nginx-unprivileged:alpine

# Vite genera los archivos compilados en la carpeta "dist", los pasamos a Nginx
COPY --from=builder /app/dist /usr/share/nginx/html

COPY nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080