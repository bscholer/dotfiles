ubuntu:
	docker build . --file Dockerfile-ubuntu -t quick-config --progress plain
	docker rm -f quick-config-test || true
	docker run -it --name quick-config-test quick-config /usr/bin/zsh

fedora:
	docker build . --file Dockerfile-fedora -t quick-config --progress plain
	docker rm -f quick-config-test || true
	docker run -it --name quick-config-test quick-config /usr/bin/zsh

