# Tag Info

- **v2.1.2, Latest (2020-03-10)** : Agensgraph-2.1.2, Centor7

# Usage
- Build Image
 - docker build -t behappy0723/agensgraph:2.1.2 .

- Pulling Image
 - docker pull behappy0723/agensgraph:2.1.2

- Starting New Container
 - docker run -it -d --name agensgraph-2.1.2 -p 5432:5432 behappy0723/agensgraph:2.1.2 /bin/bash

- Running Commands in the Running Container
 - **agens user** : docker exec -it agensgraph-2.1.2 bash
 - **root user** : docker exec --interactive --tty --user root --workdir / agensgraph-2.1.2 bash

# Notice
- This is not an official image provided by Bitnine.
- The images provides only the default installation and setting of agensgraph.
- Users need to run commands such as creating user and database on their own in the running container.
- The data directory($AGDATA) in the container is **/home/agens/agensgraph-2.1.2/data**, so if users want to remain the data on local machine, refer the path for volume.
- For commands or other environment setting, refer [Bitnine official document](https://bitnine.net/documentations/manual/agens_graph_developer_manual_en.html).
