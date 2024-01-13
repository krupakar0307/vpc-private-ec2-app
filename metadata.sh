#!/bin/bash

# Function to print colored and blinking text
print_color() {
    echo -e "<h1 style=\"color: black; text-decoration: blink;\">$1</h1>"  # Black color and blinking for headlines
    echo -e "<p style=\"color: black;\">$2</p>"   # Black color for content
}

# Retrieve instance metadata
instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
vpc_id=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/)/vpc-id)
subnet_id=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/)/subnet-id)

# Create HTML page
cat <<EOF > /var/www/html/index.nginx-debian.html 
<!DOCTYPE html>
<html>
<head>
    <title>Instance Metadata</title>
</head>
<body>
    $(print_color "Instance Metadata:" "")
    $(print_color "Instance ID:" "$instance_id")
    $(print_color "VPC ID:" "$vpc_id")
    $(print_color "Subnet ID:" "$subnet_id")
</body>
</html>
EOF

# Restart Nginx to apply changes
sudo systemctl restart nginx
