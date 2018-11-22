function pretty_print(){
  tput setaf 1; echo $1
}

function is_app_installed(){
  if ls /Applications/ | grep -i $1 > /dev/null; then
    return 0;
  else
    return 1;
  fi
}

function install(){
   if ! command -v $1 > /dev/null; then
    pretty_print "Installing $1" 
    brew install $1 --$2
  else
    pretty_print "$1 is already installed"
  fi
}

function append_to_zshrc(){
  if ! grep "$1" $HOME/.zshrc > /dev/null; then
    echo "$1" >>  ~/.zshrc
    exec /bin/zsh
    source ~/.zshrc
  fi
}

function setup_brew(){
  if ! command -v brew > /dev/null; then
    pretty_print "Installing brew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    pretty_print "Brew is already installed"
  fi
}

function setup_vimrc(){
  git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
  sh ~/.vim_runtime/install_awesome_vimrc.s
}

function install_iterm(){
  pretty_print "Setup Iterm"
  is_app_installed iterm
  if [[ "$?" = 0 ]]; then
    echo "iterm already installed"
  else
    brew cask install iterm2
  fi
}

function setup_zsh(){
  install zsh
  if [ ! -d /Users/tessie/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  fi
  if [ "$(command -v zsh)" != '/usr/local/bin/zsh' ] ; then
    shell_path="$(command -v zsh)"
    if ! grep "$shell_path" /etc/shells > /dev/null 2>&1 ; then
      pretty_print "Adding '$shell_path' to /etc/shells"
      sudo sh -c "echo $shell_path >> /etc/shells"
    fi
    sudo chsh -s "$shell_path" "$USER"
  fi
  if [ ! -d ~/.zsh/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
    append_to_zshrc "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
  fi
}

function setup_python3(){
  install python3
  if ! pip3 show pipenv >/dev/null; then
    pip3 install pipenv --user
  fi
}

function setup_python2(){
  if ! command -v pip >/dev/null; then
    pretty_print "Setting up pip"
    sudo easy_install pip
  fi
  if ! pip show pipenv >/dev/null; then
    pip install pipenv --user
  fi
}

function install_rbenv() {
  install rbenv
  eval "$(rbenv init -)"
}
function setup_rust(){
  install rustup
  source $HOME/.cargo/env
}

function setup_javascript_packages(){
  install yarn --without-node
  install node
}

setup_brew
brew update
brew upgrade --all
install vim
install git
install wget --with-iri
install imagemagick --with-webp
install rename
install tree
install jq
install_iterm
setup_zsh
setup_python3
setup_python2
install pyenv
install_rbenv
setup_javascript_packages
setup_rust
brew cask install firefox
brew cask install visual-studio-code
brew cask install docker
brew cask install rubymine
brew cask install webstorm