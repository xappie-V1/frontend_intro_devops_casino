# ---------- Builder ----------
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# ---------- Runtime ----------
FROM nginxinc/nginx-unprivileged:1.27-alpine AS runtime
# Copiar archivos compilados de Angular
COPY --from=builder --chown=nginx:nginx /app/dist/casino-frontend/browser/ /usr/share/nginx/html/
# Configuración de nginx
COPY --chown=nginx:nginx nginx.conf /etc/nginx/templates/default.conf.template
# Ejecutar como usuario no root
USER nginx
# Puerto interno del contenedor
EXPOSE 8080