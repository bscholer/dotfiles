ubuntu:
	docker build . --file Dockerfile-ubuntu -t quick-config & docker stop quick-config-test && docker rm quick-config-test
	wait
	docker run -it -d --name quick-config-test quick-config && docker exec -it quick-config-test /bin/bash

fedora:
	docker build . --file Dockerfile-fedora -t quick-config & docker stop quick-config-test && docker rm quick-config-test
	wait
	docker run -it -d --name quick-config-test quick-config && docker exec -it quick-config-test /bin/bash
