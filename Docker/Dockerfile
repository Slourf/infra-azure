FROM nginx:latest


USER root
RUN apt update \ 
     && apt install -y --no-install-recommends dialog \
     && apt update \
     && apt install -y --no-install-recommends openssh-server \
     && apt install -y iproute2 \
     && echo "root:Docker!" | chpasswd 

EXPOSE 2222 80

COPY sshd_config /etc/ssh/
COPY startup.sh .
RUN chmod +x startup.sh

ENTRYPOINT [ "./startup.sh", "nginx", "-g", "daemon off;" ]