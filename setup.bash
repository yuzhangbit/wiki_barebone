#!/bin/bash
set -e
PORT=8888
COMMAND="wiki"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # get the absolute path to the script file
RUBY_VERSION=2.3.4    # please keep the version number is the same with the one in install script
main()
{

    REPO_NAME=$(basename $SCRIPT_DIR)   # get name of this repo
    prepare_service_bash    # create service.bash file
    prepare_service_command  # create wiki.conf file
    load_configuration       # load configuration and service
    create_autostart_app    # create wiki.desktop file
    running_service
    echo "localhost:${PORT}"
}

running_service()
{
    start "$COMMAND"
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
        echo "Already have the autostart folder."
    else
        mkdir -p ~/.config/autostart
    fi
    APP="$COMMAND.desktop"
    cd "$SCRIPT_DIR"
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
    cd "$SCRIPT_DIR"
    touch service.bash
    echo "#!/bin/bash" > service.bash
    echo "set -e" >> service.bash
    echo "cd $SCRIPT_DIR/" >> service.bash
    echo "~/.rbenv/versions/$RUBY_VERSION/bin/gollum --config config --port $PORT" >> service.bash
    sudo chmod a+x service.bash
    echo "Created service.bash file"
}

prepare_service_command()  # create wiki.conf file
{
    cd "$SCRIPT_DIR"
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
    sudo chmod a+x "$COMMAND.conf"
}

main
