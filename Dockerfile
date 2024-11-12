FROM centos
MAINTAINER vikash@gmail.com
RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN yum -y install java
CMD /bin/bash
RUN yum install -y httpd
RUN yum install -y zip
RUN yum install -y unzip
ADD https://templatemo.com/download/templatemo_589_lugx_gaming /var/www/html/
WORKDIR /var/www/html/
RUN unzip -q templatemo_589_lugx_gaming.zip
RUN cp -rvf templatemo_589_lugx_gaming/* .
RUN rm -rf templatemo_589_lugx_gaming  templatemo_589_lugx_gaming .zip
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80



