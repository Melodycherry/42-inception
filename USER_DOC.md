User documentation This file must explain, in clear and simple terms, how an end user or administrator can:  

◦ Understand what services are provided by the stack. 
◦ Start and stop the project.  
◦ Access the website and the administration panel.  
◦ Locate and manage credentials.  
◦ Check that the services are running correctly.  

---


STEPS :
1 - Launch the VM in Oracle virtual Box  
2 - For easy copy-paste, use another terminal via `ssh -p 2222 mlaffita@localhost`
3 - According to the subject, use these 2 commands 
`docker stop $(docker ps -qa); docker rm $(docker ps -qa); docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q) 2>/dev/null`
`sudo rm -rf /home/student_login/data/*`
This will remove all the docker + volumes already set-up
4 - Import the project (normal terminal, not ssh)`scp -P 2222 -r ~/Desktop/42-inception mlaffita@localhost:~/`
5 - Import the .env file `scp -P 2222 ~/Desktop/doc-pour-inception/.env mlaffita@localhost:~/42-inception/`
6 - Import the secret folder `scp -P 2222 ~/Desktop/doc-pour-inception/.env mlaffita@localhost:~/42-inception/`
7 - Now you can `make`

**How Docker and docker compose work**  
DOCKER : A tool that use containers to package an application.  Share the host operating system, so very lightweight  
DOCKER COMPOSE : Tool that coordinate multi container setups. Instead of doing a manuel `docker build` and `docker run`, the file docker-compose.yml will configure all service at once. Will be excecuted in the makefile with make, docker compose up  

**The difference between a Docker image used with docker compose and without docker compose**  
Without compose, the images are build individually, but with compose, the orchestration is automated. Images are the same, but they will be build automatically from the dockerfile adn everything inside the docker compose.  

**The benefit of Docker compared to VMs**  
VM virtualize physical hardware and require a complete OS. So it consume significant RAM, storage, and CPU. Container isolatie app and share the same kernel, so consume less ressources.  
Docker container are much faster to start, and docker guarantee that the software environemment runs identically no matter the machine.  

**The pertinence of the directory structure required for this project (an example is provided in the subject's PDF file)**  
Each service is in its own folder. Assure modularity. The folder srcs/ contain all the diff services. And the root makefile starts it all.  

**SSL/TLS certificate**  
mlaffita.42.fr is a private domain. It is redirected from 127.0.0.1, so we cannot obtain a certified authority. The certificate is signed locally with openSSL (self-signed) so there is a warning for the user. The subject says *that the use of a TLS v1.2 or TLS v1.3 certificate is mandatory. . The SSL/TLS certificate doesn't have to be recognized. A self-signed certificate warning may appear.*
So the connexion is ok with a https.  
Firefox keeps the cache in memory, that's why the http is automatically transformed into a https. To check the correct behavior, you have to use the curl command :  
`Curl -k https://mlaffita.42.fr` -> should display 
``Curl -k http://mlaffita.42.fr` -> should fail 

**Docker image**
To check the docker images, `docker images`. Same name as the corresponding service, with tag latest. 

**Docker network**  
Show the docker-compose.yml.  The network is visible with bridge.  
Each service contain the ligne : inception_network
To check network, `docker network ls` : display srcs_inception_network  
It should display srcs_ because it use the name of the parent folder. 
To check further `docker network inspect srcs_inception_network`
Each service is interconnected under the same network.  

**Containers**
To check the containers, use the `docker compose ps`  
It has to be in the folder of the srcs 

**Volumes**
To check volumes, `docker volume ls`, and then `docker volume inspect <volume name>` 

**Add a comment**
You can use in the wp-admin dashboard a comment, or modify and existing one. 

**Check Mariadb**
To access the data base `docker exec -it mariadb mysql -u root -p` and then type the password ( be careful, it's the password provided in the secret)  
then you have to :
```
USE wordpress;

SHOW TABLES;

SELECT ID, user_login, user_email FROM wp_users;

EXIT;
```

**Persistence**
You have to reboot the machine : 
`sudo poweroff` , and then launch the VM again, `make`
Access again the website, and check if the articles, or modifications are still there.  
The date are kept thanks to the volumes stored in home/mlaffita/data. So the shutdown does not affect them.  