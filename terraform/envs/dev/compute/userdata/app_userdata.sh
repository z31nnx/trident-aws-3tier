#!/bin/bash
# Update system
dnf update -y

# Install Apache
dnf install -y httpd

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Install MySQL/MariaDB client
dnf install mariadb105 

# Create demo app page (simulate application logic)
mkdir -p /var/www/html/app
echo "<h1>Trident App Tier - Connected to Database $(hostname -f)</h1>" > /var/www/html/app/index.html