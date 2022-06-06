# Dotfiles!

I got tired of having to either copy and paste dotfiles into new systems, or just go without having a lot of my tooling on new systems. This solves that problem. Just run one command, and it will install everything (list below)! Ta-da 🎉!

This repo started life as [gjunkie's dotfiles-starter-kit](https://github.com/gjunkie/dotfiles-starter-kit/blob/main/install), but has been added to and modified significantly. It also takes some bits from [jotyGill's ezsh](https://github.com/jotyGill/ezsh).

## Install

```bash
bash -c "$(wget https://raw.github.com/bscholer/dotfiles/master/install.sh -O -)"
```

## What it does

1. If using `apt` or `dnf`, updates
1. Install a handful of what I consider to be necessary programs
2. Install [oh-my-zsh](https://ohmyz.sh/)
3. Install zsh plugins
    - [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
    - [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting.git)
    - [zsh-completions](https://github.com/zsh-users/zsh-completions)
    - [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)
1. Install [colorls](https://github.com/athityakumar/colorls)
2. Install node stuff
    - [nvm](https://github.com/nvm-sh/nvm)
    - [node.js and npm](https://nodejs.org/en/)
    - [yarn](https://yarnpkg.com/)
1. Install [Nerd fonts](https://www.nerdfonts.com/)
    - Hack
    - Roboto Mono
    - DejaVu Sans Mono
1. Install [powerlevel10k](https://github.com/romkatv/powerlevel10k)
2. Download this repo
3. Symlink dotfiles
    1. Backup existing dotfiles in `${HOME}/.dotfiles/backup`
1. Install [vundle](https://github.com/VundleVim/Vundle.vim) and `vim` plugins (only the big ones are below) (see [.vimrc](https://github.com/bscholer/dotfiles/blob/master/configs/.vimrc) for full list)
    - [NERDTree](https://github.com/preservim/nerdtree)
    - [vim-airline](https://github.com/vim-airline/vim-airline) and associated plugins
    - [CoC](https://github.com/neoclide/coc.nvim) (auto-completion and more)
    - [fzf](https://github.com/junegunn/fzf.vim) (fuzzy-find)
    - [vim-fugitive](https://github.com/tpope/vim-fugitive)
    - [auto-pairs](https://github.com/jiangmiao/auto-pairs)
1. Set Git authorship (set your name at the top of [install.sh](https://github.com/bscholer/dotfiles/blob/master/install.sh))
2. Generate SSH key for addition to GitHub
3. Set default shell to `zsh`
