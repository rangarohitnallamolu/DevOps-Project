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


WORKDIR /var/www/html/
RUN curl -o neogym.zip "https://www.free-css.com/assets/files/free-css-templates/download/page254/neogym.zip"
RUN ls -l /var/www/html/
RUN sh -c 'unzip -q "*.zip"'
RUN cp -rvf neogym/* .
RUN rm -rf neogym  neogym.zip
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80



