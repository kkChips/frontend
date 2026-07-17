# 构建阶段（使用阿里云 Docker Hub 镜像）
FROM registry.cn-hangzhou.aliyuncs.com/library/node:20-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build

# 运行阶段：nginx 托管静态文件（使用阿里云 Docker Hub 镜像）
FROM registry.cn-hangzhou.aliyuncs.com/library/nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
