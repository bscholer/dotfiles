.PHONY: ubuntu fedora apply diff clean-test

# Build & run a fresh ubuntu container against the current working tree.
ubuntu:
	docker build . --file Dockerfile-ubuntu -t dotfiles-ubuntu --progress plain
	docker rm -f dotfiles-test || true
	docker run -it --name dotfiles-test dotfiles-ubuntu /usr/bin/zsh

fedora:
	docker build . --file Dockerfile-fedora -t dotfiles-fedora --progress plain
	docker rm -f dotfiles-test || true
	docker run -it --name dotfiles-test dotfiles-fedora /usr/bin/zsh

# Re-apply the local working tree to the host (handy while iterating).
apply:
	chezmoi apply --source=$(CURDIR)

# Show what `chezmoi apply` would change without changing anything.
diff:
	chezmoi diff --source=$(CURDIR)

clean-test:
	docker rm -f dotfiles-test || true
