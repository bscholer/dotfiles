# Dotfiles

My personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Fresh machine

```bash
curl -fsSL https://raw.githubusercontent.com/bscholer/dotfiles/master/bootstrap.sh | bash
```

That installs chezmoi (via brew on macOS, the official installer on Linux),
clones this repo to `~/.local/share/chezmoi`, prompts for a couple of values
(name, email, whether to install Node/NvChad), and applies everything.

## Layout

```
.
├── bootstrap.sh                # one-shot installer for new machines
├── packages/                   # everything the system package manager owns
│   ├── Brewfile                # macOS — `brew bundle`
│   ├── apt.txt                 # Linux/Debian — one package per line
│   ├── dnf.txt                 # Linux/Fedora — one package per line
│   └── install.sh              # detects OS, installs the right list,
│                               # plus extras (lazygit/lazydocker/gh/zoxide
│                               # /nerd fonts on Linux)
├── home/                       # chezmoi source dir
│   ├── .chezmoi.toml.tmpl      # prompts that populate template vars
│   ├── dot_zshrc               # → ~/.zshrc
│   ├── dot_p10k.zsh            # → ~/.p10k.zsh
│   ├── dot_tmux.conf
│   ├── dot_vimrc / dot_ideavimrc / dot_vscodevimrc
│   ├── dot_config/nvim/lua/custom/...   # NvChad overlays
│   ├── run_onchange_before_10-install-packages.sh.tmpl   # invokes packages/install.sh
│   └── run_once_after_*.sh                               # bootstrap omz, p10k,
│                                                        # tpm, NvChad, nvm,
│                                                        # ssh key, default shell
└── .chezmoiroot                # tells chezmoi the source is `home/`
```

## Day-to-day

| What you want | What to run |
| --- | --- |
| Apply local changes | `make apply` (or `chezmoi apply --source=$PWD`) |
| Preview changes | `make diff` |
| Add a config you've been editing in `$HOME` | `chezmoi add ~/.foo` |
| Pull and apply (other machine) | `chezmoi update` |
| Re-run package install | `packages/install.sh` |
| Re-run a `run_once_` script | edit it, or `chezmoi state delete-bucket --bucket=scriptState` |

## Machine-specific tweaks

`~/.zshrc` sources `~/.zshrc-local` if it exists. Put per-machine PATH
additions, work-only aliases, and anything injected by GUI apps (Rancher
Desktop, Antigravity, etc.) there — keeps the dotfiles repo portable.

## Containers

```bash
make ubuntu    # build & shell into a fresh ubuntu image with the dotfiles applied
make fedora    # same for fedora
```

Both Dockerfiles `COPY` the local working tree, so you can test uncommitted
changes before pushing.
