# 🚀 My Ultimate Dev Setup

Hey! I got tired of setting up my development environment from scratch on new machines, so I automated everything. One command, and you get my entire carefully curated dev setup. Pretty neat, right? 🎉

## 🌟 What's Cool About It?

- 🛠️ **Works Everywhere**: I've made it work on Linux, macOS, and BSD because I use different systems
- 🔄 **Smart Setup**: Figures out what package manager you're using and just works (hopefully)
- 🔒 **No Fuss**: Sets up SSH keys and GitHub config automatically
- 🎨 **Looks Good**: Because life's too short for ugly terminals
- ⚡ **Fast**: Because I'm impatient

## 🚀 Just Run This

```bash
wget --quiet -O - https://raw.github.com/bscholer/dotfiles/master/install.sh | bash -s
```

## ✨ What You Get

### 🔧 The Good Stuff
- All the essential dev tools (git, vim, curl, wget, etc.)
- Some awesome modern replacements I can't live without:
  - 🌈 [colorls](https://github.com/athityakumar/colorls) - Makes `ls` actually nice to look at
  - 📊 [gotop](https://github.com/cjbassi/gotop) - Pretty system monitoring
  - 🐳 [lazydocker](https://github.com/jesseduffield/lazydocker) - Docker without the headache
  - 📝 [lazygit](https://github.com/jesseduffield/lazygit) - Git but better

### 🐚 Terminal Setup
- [Oh My Zsh](https://ohmyz.sh/) with my favorite plugins:
  - zsh-autosuggestions (because typing is overrated)
  - zsh-syntax-highlighting
  - zsh-completions
  - zsh-history-substring-search
- ⚡ [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme (it's gorgeous!)

### 📝 Neovim Setup
- [Neovim](https://neovim.io/) with [NvChad](https://nvchad.com/) (because I like my editor fancy)
- LSP support via Mason
- Copilot integration (my favorite pair programmer)
- Lazy plugin management

### 🔤 Dev Environment
- Node.js with nvm (because version management should be easy)
- Python virtual environment support
- Ruby and Go setups
- My favorite coding fonts:
  - JetBrains Mono Nerd Font
  - Hack Nerd Font
  - Roboto Mono Nerd Font
  - DejaVu Sans Mono Nerd Font

## 🎨 Make It Yours

### Local Tweaks
Got machine-specific settings? Drop them in `~/.zshrc-local` and they'll just work.

### Git Setup
The script will:
1. Set up your Git identity
2. Generate SSH keys for GitHub
3. Switch to SSH for future operations

## 🔄 Keeping It Fresh

Stay up to date with:

```bash
cd ~/.dotfiles && git pull
```

## 🙌 Credit Where It's Due

This started as a fork of [gjunkie's dotfiles-starter-kit](https://github.com/gjunkie/dotfiles-starter-kit/blob/main/install), but I've added a bunch of stuff I use daily. Thanks for the inspiration!
