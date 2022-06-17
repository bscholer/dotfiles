ubuntu:
	sudo docker build . --file Dockerfile-ubuntu -t quick-config & sudo docker stop quick-config-test && sudo docker rm quick-config-test
	wait
	sudo docker run -it -d --name quick-config-test quick-config && sudo docker exec -it quick-config-test /bin/bash

fedora:
	sudo docker build . --file Dockerfile-fedora -t quick-config & sudo docker stop quick-config-test && sudo docker rm quick-config-test
	wait
	sudo docker run -it -d --name quick-config-test quick-config && sudo docker exec -it quick-config-test /bin/bash
