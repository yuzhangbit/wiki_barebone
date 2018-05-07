#!/bin/bash
set -e
RUBY_VERSION=2.3.4
rbenv_name=".rbenv"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" ## It is the absolute path where this script lies.

main()
{
    install_apt_dependencies
    install_rbenv_gollum     # install dependencies
}


install_apt_dependencies()
{
    sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev g++ libicu-dev build-essential
}


install_rbenv_gollum()
{
    cd $HOME && if [[ ! -d $rbenv_name ]]; then
        # cannot find rbenv , download it then
        echo "Start installing rbenv....."
        wget -q https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer -O- | bash || true
    else
        # find the .rbenv, pull the latest changes to the master branch
        echo "Update the rbenv through git......"
        cd $rbenv_name && git reset --hard && git checkout master && git pull
    fi

    # rbenv need login shell, setup environment for rbenv
    if [ -d ~/.bash_profile ]; then
 	if (grep "-f ~/.bashrc" ~/.bash_profile); then
	    echo "Already set up!"
        else
	    echo 'if [ -f ~/.bashrc ]; then . ~/.bashrc; fi' >> ~/.bash_profile
        fi
    else
        touch ~/.bash_profile
        echo 'if [ -f ~/.bashrc ]; then . ~/.bashrc; fi' >> ~/.bash_profile
    fi
    if (grep 'export PATH="$HOME/.rbenv/bin:$PATH"' ~/.bashrc); then
        echo "The PATH for rbenv is already set."
    else
        echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    fi

    if (grep 'eval "$(rbenv init -)"' ~/.bashrc); then
        echo "rbenv initialized."
    else
        echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    fi
    echo "rbenv initialized successfully....."
    # temperally set up the env to install the following packages.
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    source ~/.bashrc
    source ~/.bash_profile

    # check if target ruby has been installed.
    if [[ "$(rbenv global)" == "$RUBY_VERSION" ]]; then
        echo "Ruby $RUBY_VERSION has beened installed."
    else
        echo "Installing ruby $RUBY_VERSION .... This is going to take a while."
        rbenv global
        rbenv install $RUBY_VERSION
        rbenv global $RUBY_VERSION
        rbenv local $RUBY_VERSION
    fi
    export RBENV_SHELL=$RUBY_VERSION

    if [[ "$(gem list -i bundler)" == true ]]; then
        echo "bundler has been installed."
    else
        echo "Install bundler to manage the ruby gem packages..."
        gem install bundler
    fi
    echo "Installing gollum........"
    bundler install --gemfile $SCRIPT_DIR/Gemfile
    echo " All ruby packages installed successfully."
}

main
