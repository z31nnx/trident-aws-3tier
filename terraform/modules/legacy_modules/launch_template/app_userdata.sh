#!/bin/bash
# Update system
yum update -y

# Install Apache
yum install -y httpd

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Install MySQL client
yum install -y mysql

# Create demo app page (simulate application logic)
mkdir -p /var/www/html/app
echo "<h1>Trident App Tier - Connected to Database $(hostname -f)</h1>" > /var/www/html/app/index.html