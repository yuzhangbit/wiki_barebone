#!/bin/bash
set -e
RUBY_VERSION=2.3.4

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
    cd $HOME
    echo "Start installing rbenv , gem , gollum....."
    # install rbenv and ruby-build
    wget -q https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer -O- | bash || true
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
    rbenv install $RUBY_VERSION
    rbenv global $RUBY_VERSION
    rbenv local $RUBY_VERSION
    export RBENV_SHELL=$RUBY_VERSION
    echo "Installing gollum........"
    gem install gollum
    gem install github-markdown
    echo " All ruby packages installed successfully."
}

main
