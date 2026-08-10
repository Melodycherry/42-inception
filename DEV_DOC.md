# Developer documentation

This document provides technical guidelines for developers maintaining or modifying the **Inception** infrastructure. 


◦ Set up the environment from scratch (prerequisites, configuration files, secrets)  

**Prerequisites**
Ensure your local environment or Virtual Machine has `docker`, `docker-compose-v2`, and `make` installed:
`sudo apt update && sudo apt install -y docker.io docker-compose-v2 make git`

◦ Project architecture  
42-inception/  
├── Makefile  
├── .env  
├── secrets/  
│   ├── db_password.txt  
│   ├── db_root_password.txt  
│   ├── wp_admin_password.txt  
│   └── wp_user_password.txt  
└── srcs/  
    ├── docker-compose.yml  
    └── requirements/  
        ├── mariadb/  
        ├── nginx/  
        └── wordpress/  


◦ Build and launch the project using the Makefile and Docker Compose. 
The Makefile automates directory creation, environment verification, and Docker Compose commands:
`make`

Stop container:  
`make down`
Cleaning ressources:  
`make clean`
Rebuild from scratch:  
`make re`

◦ Docker compose commande 
```
# Build images and start containers in detached mode
docker compose -f srcs/docker-compose.yml up -d --build

# Stop containers without removing volumes
docker compose -f srcs/docker-compose.yml stop

# Stop and remove containers, networks, and volumes
docker compose -f srcs/docker-compose.yml down -v
```

◦ Use relevant commands to manage the containers and volumes.
Inspecting Container Status  
```
# List running containers
docker ps

# Check all containers and their exit codes
docker ps -a
```
Inspecting Container Logs  
```
# View NGINX logs
docker logs nginx

# View WordPress/PHP-FPM logs
docker logs wordpress

# View MariaDB logs
docker logs mariadb
```
 
◦ Identify where the project data is stored and how it persists.   
Data persistence is managed via Docker Named Volumes mapped to the host filesystem inside /home/mlaffita/data/
Check configuration in docker-compose.yml  
```
volumes:
  wp_data:
    name: wp_data
    driver: local
    driver_opts:
      type: 'none'
      o: 'bind'
      device: '/home/mlaffita/data/wordpress'

  db_data:
    name: db_data
    driver: local
    driver_opts:
      type: 'none'
      o: 'bind'
      device: '/home/mlaffita/data/mariadb'
```

**Verification**  
List docker volume:  
`docker volume ls`
Verify Host Storage Content:  
```
ls -la /home/mlaffita/data/wordpress
ls -la /home/mlaffita/data/mariadb
```


**Persistency Test Procedure:**    
1	Modify an article or site option on WordPress.  
2	Stop and remove containers: docker compose -f srcs/docker-compose.yml down.  
3	Relaunch stack: docker compose -f srcs/docker-compose.yml up -d.  
4	Verify that the changes persist on the site.  
