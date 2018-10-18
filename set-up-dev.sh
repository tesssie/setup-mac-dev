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

function setup_brew(){
  if ! command -v brew > /dev/null; then
    pretty_print "Installing brew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    pretty_print "Brew is already installed"
  fi
}

function install_vim(){
  if ! command -v vim > /dev/null; then
    pretty_print "Installing vim" 
    brew install vim
  else
    pretty_print "Vim is already installed"
  fi
}

function setup_git(){
  if ! command -v git > /dev/null; then
    pretty_print "Install git"
    brew install git
  else
    pretty_print "git is already installed"
  fi
}

function configure_git(){
  pretty_print "Configuring git"
  pretty_print "Enter Username"
  read user_name
  git config --global user.name $username
  pretty_print "Configure git email"
  read user_email
  git config --global user.email $user_email
  pretty_print "Configuring vim as editor"
  git config --global core.editor vim
  pretty_print "Push behavior"
  git config --global push.default current
  git config --list
}

function setup_extra_utilities(){
  if ! command -v wget >/dev/null; then
    pretty_print "Install wget"
    brew install wget --with-iri
  fi
  if ! command -v convert >/dev/null; then
    pretty_print "Install imagegmagic"
    brew install imagemagick --with-webp
  fi
  if ! command -v rename >/dev/null; then
    pretty_print "Rename"
    brew install rename
  fi
  if ! command -v tree >/dev/null; then
    pretty_print "Tree"
    brew install tree
  fi
  if ! command -v jq >/dev/null; then
    pretty_print "jq"
    brew install jq
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
  which zsh
  if [[ "$?" = 0 ]]; then
    pretty_print "zsh is already installed"
  else
    brew install zsh
  fi
  brew install zsh-completions
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  sudo chsh -s $(which zsh)
  if [ ! -d ~/.zsh/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions 
    echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >>  ~/.zshrc
    exec /bin/zsh
    source  ~/.zshrc
  fi
}

function setup_python3(){
  if ! command -v python3 >/dev/null; then
    brew install python3
  else
    pretty_print "Python3 is already installed"
  fi
  if ! pip3 show virtualenv >/dev/null; then
    pip3 install virtualenv --user
  fi
  if ! pip3 show pipenv >/dev/null; then
    pip3 install pipenv --user
  fi
}

function setup_python2(){
  if ! command -v pip >/dev/null; then
    pretty_print "Setting up pip"
    sudo easy_install pip
  fi  
  if ! pip show virtualenv >/dev/null; then
    pip install virtualenv --user
  fi
  if ! pip show pipenv >/dev/null; then
    pip install pipenv --user
  fi
}

setup_brew
brew update
brew upgrade --all
install_vim
setup_git
setup_extra_utilities
pretty_print "Want to configure git y/n?"
read option
if [[ "$option" = "y" ]]; then
  configure_git
fi
install_iterm
setup_zsh
setup_python3
setup_python2
