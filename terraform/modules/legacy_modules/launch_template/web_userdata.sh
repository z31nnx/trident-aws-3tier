#!/bin/bash
#Update OS and install Apache
yum update -y
yum install -y httpd

# Enable and start the service
systemctl enable httpd
systemctl start httpd

# Create simple HTML response
echo "<h1>Hello from Trident Web Tier  $(hostname -f)</h1>" > /var/www/html/index.html