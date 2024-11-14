FROM centos

# Update package lists and install required packages
RUN yum update -y && \
    yum install -y java unzip httpd

# Download the portfolio archive
RUN curl -L https://github.com/rangarohitnallamolu/portfolio/archive/refs/heads/master.zip -o /tmp/portfolio.zip

# Extract the portfolio files
WORKDIR /var/www/html
COPY /tmp/portfolio.zip .
RUN unzip -q "*.zip" && rm -rf portfolio-master.zip

# Set the default document root
RUN ln -s portfolio-master/public /var/www/html/index.html

# Expose port 80 and start the web server
EXPOSE 80
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]