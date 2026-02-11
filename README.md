# 🐳 Docker Development Stack

This repository contains a complete Docker‑based development environment using **Docker Compose v3.8**.
It includes MySQL, MinIO, MailHog, Meilisearch, Redis, Kong, and Konga — ready for local development.

## 📦 Included Services

### **1. MySQL 8.4.8**
Relational database engine with preconfigured users and persistent storage.

**Connection:**
```
Host: localhost
Port: 3306
User: developer
Password: password
Database: test
```

---

### **2. MinIO**
S3‑compatible object storage.

**Ports:**
- API: 9000
- Console: 8900

**Access:**
```
Web UI: http://localhost:9000
```

Credentials:
```
MINIO_ROOT_USER=developer
MINIO_ROOT_PASSWORD=password
```

---

### **3. MailHog**
Local SMTP testing server.

**Access:**
```
SMTP: localhost:1025
Web UI: http://localhost:8025
```

---

### **4. Meilisearch v1.3.1**
Fast, modern search engine.

**Access:**
```
http://localhost:7700
```

---

### **5. Redis (Alpine)**
Key‑value store for caching/queues.

**Connection:**
```
Host: localhost
Port: 6379
```

---

### **6. Kong**
API Gateway running in declarative mode.

**Ports:**
```
8000 / 8443 - Proxy
8001 / 8444 - Admin
```

Configuration comes from:
```
./docker/kong/kong.yaml
```

---

### **7. Konga**
UI dashboard for managing Kong.

**Access:**
```
http://localhost:1337
```

---

## 🚀 Getting Started

### **Start all services**
```sh
docker compose up -d
```

### **Stop all services**
```sh
docker compose down
```

### **Remove volumes (optional)**
```sh
docker compose down -v
```

---

## 🗂️ Project Structure
```
./docker
 ├── mysql/create-testing-database.sh
 ├── minio/entrypoint.sh
 └── kong/kong.yaml
```

---

## 🧰 Volumes
```
local-mysql
local-minio
local-meilisearch
local-redis
```

---

## 📄 License
Free to use and modify for development.
