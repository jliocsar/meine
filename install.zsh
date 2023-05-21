. ./utils.zsh

echo_title "Installing deps"
sudo apt install -y \
  zsh \
  bat \
  tree

# Checks for oh-my-zsh and installs it if not present
if [ -d ~/.oh-my-zsh ]; then
  echo_success "oh-my-zsh already installed, proceeding..."
else
  echo_info "oh-my-zsh not found, installing..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Installs Zinit if not installed yet
if command -v zinit &> /dev/null; then
  echo_success "Zinit already installed, proceeding..."
else
  echo_info "Zinit not found, installing..."
  bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
fi

if command -v nvim &> /dev/null; then 
  echo_success "Neovim already installed, proceeding..."
else
  echo_info "Neovim not found, installing..."
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod u+x ./nvim.appimage
  sudo mv ./nvim.appimage /usr/bin/nvim
fi

if [ -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
  echo_success "vim-plug already installed, proceeding..."
else
  echo_info "vim-plug not found, installing..."
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

# Checks for nvm and installs it if not present
if [ -d ~/.nvm ]; then
  echo_success "nvm already installed, proceeding..."
else
  echo_info "nvm not found, installing..."
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
fi


echo_info "Adding init.vim..."
echo 'source $HOME/.meine/vim/init.vim' > ~/.config/nvim/init.vim

echo_info "Remember to install spaceship-prompt and set \`ZSH_THEME="spaceship"\` in the .zshrc file"

# Last path
# Source the custom config if it's not present in the .zshrc file
if grep_zshrc "zsh_custom_config"; then
  echo_success "ZSH Custom Config already sourced, proceeding..."
else
  echo_info "Sourcing ZSH Custom Config..."
  echo 'source ~/.meine/zsh_custom_config.zsh' >> ~/.zshrc
fi

# Run nvim & update/install plugins
nvim -c ':PlugInstall' \
     -c 'qa!'
