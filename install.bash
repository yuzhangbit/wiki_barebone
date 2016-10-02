#!/bin/bash 

PORT=4444
COMMAND="wiki"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # get the absolute path to the script file
RUBY_VERSION=2.2.4

main()
{
    
    install_rbenv_gollum     # install dependencies
    REPO_NAME=$(basename $SCRIPT_DIR)   # get name of this repo
    prepare_service_bash    # create service.bash file
    prepare_service_command  # create wiki.conf file
    load_configuration       # load configuration and service 
    create_autostart_app    # create wiki.desktop file
}

load_configuration()
{
    echo "Prepare auto start service for the wiki."
    if [ -d ~/.init ]; then
        echo "Init folder is already there!"
    else
        mkdir -p ~/.init
    fi
    cp -r $SCRIPT_DIR/$COMMAND.conf ~/.init
    initctl reload-configuration
    echo "Start the service!"
}

create_autostart_app()   # will create a wiki.desktop file. 
{
    if [ -d ~/.config/autostart ]; then
        echo "Already has autostart folder."
    else 
        mkdir -p ~/.config/autostart
    fi  
    APP="$COMMAND.desktop"
    touch $APP
    echo '[Desktop Entry]' > $APP
    echo "Type=Application" >> $APP    
    echo "Exec=start $COMMAND" >> $APP 
    echo "Hidden=false" >> $APP
    echo "NoDisplay=false" >> $APP
    echo "X-GNOME-Autostart-enabled=true" >> $APP
    echo "Name[en_CA]=$COMMAND" >> $APP
    echo "Name=$COMMAND" >> $APP
    echo "Comment[en_CA]=empty" >> $APP
    echo "Comment=empty" >> $APP
    cp -r $APP ~/.config/autostart/
}

prepare_service_bash()
{
    touch service.bash
    echo "#!/bin/bash" > service.bash
    echo "set -e" >> service.bash
    echo "cd $SCRIPT_DIR/" >> service.bash
    echo "$HOME/.rbenv/versions/$RUBY_VERSION/bin/gollum --config $SCRIPT_DIR/config --port $PORT" >> service.bash
    sudo chmod a+x service.bash
    echo "Created service.bash file"
}

prepare_service_command()  # create wiki.conf file 
{
    touch $COMMAND.conf
    echo '#' > $COMMAND.conf
    echo 'description     "Gollum Wiki"' >> $COMMAND.conf
    echo 'author          "Yu Zhang <yu.zhang.bit@gmail.com>"' >> $COMMAND.conf
    echo 'version      	   "1.0"' >> $COMMAND.conf
    echo 'start on runlevel [2345]' >> $COMMAND.conf
    echo 'stop on runlevel [!2345]' >> $COMMAND.conf
    echo 'respawn'  >> $COMMAND.conf
    echo "exec /bin/bash $SCRIPT_DIR/service.bash" >> $COMMAND.conf
    echo "Created the $COMMAND.conf file."
}

install_rbenv_gollum()
{
    cd $HOME
    echo "start installing rbenv , gem , gollum....."
    if [ -d ~/.rbenv ]; then 
        echo "Find rbevn."
    else
        git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    fi
    if [ -d ~/.rbenv/plugins/ruby-build ]; then
        echo "Find ruby build"   
    else
	    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    fi
	cd ~/.rbenv && src/configure && make -C src
	if [ -d ~/.bash_profile ]; then
		echo "bash_profile exists."
	else
		touch ~/.bash_profile
	fi
	if (grep "bashrc" ~/.bash_profile); then 
		echo " bash_profile is already set up."
	else 
		echo 'if [ -f ~/.bashrc ]; then . ~/.bashrc; fi' >> ~/.bash_profile
	fi
	if (grep 'export PATH=$HOME/.rbenv/bin:$PATH' ~/.bashrc); then
		echo "Bashrc is already set up for rbenv."
	else
		echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
	fi
	if (grep 'eval "$(rbenv init -)"' ~/.bashrc); then
		echo 'rbenv is already setup.'
	else
		echo 'eval "$(rbenv init -)"' >> ~/.bashrc

	fi	
	~/.rbenv/bin/rbenv init || true
	echo "rbenv initialized successfully....." 
	source ~/.bash_profile
	source ~/.bashrc
	~/.rbenv/bin/rbenv install $RUBY_VERSION
	rbenv global $RUBY_VERSION
	rbenv local $RUBY_VERSION 
	echo "Installing bundler, gollum, jekyll........"
	gem install gollum 
	echo " All ruby packages installed successfully."
}

main
