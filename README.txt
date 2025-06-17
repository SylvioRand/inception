
# Project Setup Instructions

## 1. Run Initialization Script

Start by executing the setup script to prepare sensitive configuration files:
./setup-sensitive-files.sh

In the srcs/ directory, create a .env file containing the following variables and their corresponding values:
DOMAIN_NAME=your_value
MYSQL_DATABASE=your_value
MYSQL_USER=your_value
FTP_USER=your_value

At the root of the cloned project directory, create a folder named secrets/. Inside this folder, include the following files:
credentials.txt
db_password.txt
db_root_password.txt
ftp_password.txt
Each file should contain the appropriate sensitive information.

Fill in credentials.txt with the following variables:
WP_ADMIN_USER=superuser42
WP_ADMIN_PASS=supersecure
WP_ADMIN_EMAIL=your_admin_email
WP_USER=your_wordpress_username
WP_USER_PASS=your_wordpress_password
WP_USER_EMAIL=your_user_email
