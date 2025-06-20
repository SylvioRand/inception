
# Sensitive Files Setup

This script (`setup-sensitive-files.sh`) generates environment and secret files required for your project.

## 🔧 What It Does

- Creates the `.env` file under the `srcs/` directory (if it doesn't exist).
- Creates the `secrets/` directory and generates the following files:
  - `db_password.txt`
  - `db_root_password.txt`
  - `ftp_password.txt`
  - `credentials.txt` (only if empty)

All passwords are generated randomly and securely.

## ▶️ How to Use

Run the script:

```bash
bash setup-sensitive-files.sh

