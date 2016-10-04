#!/bin/bash 
set -e
RUBY_VERSION=2.2.4

main()
{
	install_rbenv_gollum     # install dependencies
}




install_rbenv_gollum()
{
    cd $HOME
    echo "Start installing rbenv , gem , gollum....."
    if [ -d ~/.rbenv ]; then 
        echo "Find rbevn."
    else
        git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    
    fi

    if [ -d ~/.rbenv/plugins/ruby-build ]; then
        echo "Find the ruby build tool !"   
    else
        git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    fi
    cd ~/.rbenv && src/configure && make -C src
    if (grep 'export PATH="$HOME/.rbenv/bin:$PATH"' ~/.bashrc); then
        echo "The PATH for rbenv is already set."
    else
        echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    fi
    source ~/.bashrc
    ~/.rbenv/bin/rbenv init || true
    echo "rbenv initialized successfully....." 
    source ~/.bashrc
    ~/.rbenv/bin/rbenv install $RUBY_VERSION
    rbenv global $RUBY_VERSION
    rbenv local $RUBY_VERSION 
    echo "Installing gollum........"
    gem install gollum 
    echo " All ruby packages installed successfully."
}

main
