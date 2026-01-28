FROM eclipse-temurin
LABEL Maintainer="Ramesh_Mamuduru"
LABEL email="rameshmamuduru7799@gmail.com"
WORKDIR /app
RUN apt-get update && \
    apt-get install curl -y && \
    apt-get install nginx -y 

COPY target/*.war /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
