FROM centos
MAINTAINER rangarohit.nallamolu@gmail.com
RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN yum -y install java
CMD /bin/bash
RUN yum install -y httpd
RUN yum install -y zip
RUN yum install -y unzip

COPY https://raw.githubusercontent.com/rangarohitnallamolu/portfolio.git /var/www/html/
WORKDIR /var/www/html/

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80 22
