*This project has been created as part of the 42 curriculum by < mlaffita >* 

# Description
The **Inception** project aims to broaden knowledge of system administration by virtualization using Docker.  
The goal is to build a complete, secure infrastructure using **Docker Compose** within a Virtual Machine.  

The stack consists of three isolated services running in separate containers: 
- **NGINX**: A web server acting as the single point of entry, configured strictly with SSL/TLS (v1.2/v1.3). 
- **WordPress**: A web application powered by PHP-FPM (port 9000) for dynamic content processing. 
- **MariaDB**: A database storing WordPress data (port 3306).
  
All services run on a custom bridge network and persist data using Docker named volumes mapped to specified host directories (`/home/mlaffita/data`).

# Instructions

### Prerequisites 
- Operating System: Linux (Debian 12 recommended) running in VirtualBox.
- Tools required: `make`, `docker`, `docker compose`, `git`, `curl`.
  
**Steps**  
1. Clone this repository. 
2. Add the file .env and the "secrets" folder containing the password and sensitive data. 
3. `Make`  
4. Open a browser and navigate to : https://mlaffita.42.fr

# Ressources

**Docker:**  
Cody tech Introduction to docker :  
https://coddy.tech/journeys/terminal/introduction_to_docker  
Official ressources from docker :
https://docs.docker.com/  
https://docs.docker.com/compose/  

**Project tutorial**  
https://tuto.grademe.fr/inception/  

**Article:**   
https://medium.com/@imyzf/inception-3979046d90a0

*How AI was used :*  
- Explanation of concepts
- Verification of scripts
- Debbuging assistance

# Project description 

◦ Virtual Machines vs Docker  
- **Virtual Machines (VMs):** 
Virtualize entire physical hardware systems. Each VM runs a full Guest Operating System (OS) with its own kernel, hypervisor abstraction layer, and system resources. This provides strong isolation but incurs significant CPU, memory, and startup overhead.   
- **Docker Containers:** Virtualize at the OS level (user space). Containers share the host kernel while isolating processes, filesystems, and network stacks via Linux `namespaces` and `cgroups`. They are lightweight, start almost instantly, and consume far fewer system resources.  

◦ Secrets vs Environment Variables     
- **Environment Variables (`.env`):**   
Passed in plain text to container environments. They are ideal for non-sensitive configuration settings (e.g., database names, domain names, application titles). However, they can leak via `docker inspect`, process inspection, or system logs.   
- **Docker Secrets:** Sensitive data (passwords, private keys, API tokens) are mounted as read-only files in an in-memory filesystem (`tmpfs`) at `/run/secrets/` inside the target container. They are never committed to image layers, logged, or exposed in plain text to unauthorized processes.

◦ Docker Network vs Host Network    
- **Host Network:**  
Containers share the host machine’s network namespace directly, bypassing network isolation. Container ports are mapped directly to host ports without NAT or proxying.   
- **Docker Network (Custom Bridge):**  
Creates an isolated virtual bridge network dedicated to the stack. Containers communicate internally using service names as hostname DNS resolution (e.g., `wordpress` reaches `mariadb` directly). External access is strictly controlled via explicitly published ports (e.g., only port `443` on NGINX).  


◦ Docker Volumes vs Bind Mounts  
- **Bind Mounts:** Directly map a host directory or file to a container path. They depend heavily on the host directory structure and host-level filesystem permissions. 
- **Docker Volumes:** Managed natively by Docker within `/var/lib/docker/volumes/`. They decouple storage implementation details from the host system.
- *Inception requirement:* Configures **Docker Named Volumes** that utilize the `local` driver with `o: bind` options to store data inside `/home/mlaffita/data/` while maintaining Docker-level volume abstraction.  
