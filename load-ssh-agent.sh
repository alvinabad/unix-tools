#!/bin/bash

#-------------------------------------------------------------------------------
# Enable ssh-agent
# Source this in ~/.profile or ~/.bash_profile
# Example:
#     . $HOME/src/unix-tools/load-ssh-agent.sh 72h 
#
# Another way to set expiration time, is to set this ENV
#     export SSH_AGENT_EXP=72h
#-------------------------------------------------------------------------------

SSH_AGENT_EXP=${SSH_AGENT_EXP=72h}

# if expiration is supplied at the command line
if [ -n "$1" ]; then
    SSH_AGENT_EXP=$1
fi

KEY_FILES="
    $HOME/.ssh/id_rsa
    $HOME/.ssh/github.pem
"
#id_rsa.aabad

SA_DIR=$HOME/.ssh
SA_FILE=${SA_DIR}/sa

create_ssh_agent() {
    # killall any ssh-agents and create a new one
    killall ssh-agent || true

    echo "Launching new ssh-sgent."
    mkdir -p $SA_DIR
    chmod 700 $SA_DIR
    ssh-agent -t $SSH_AGENT_EXP > $SA_FILE
    . $SA_FILE

    for k in $KEY_FILES
    do
        #ssh-add -t 72h $HOME/.ssh/$k
        echo ----------------------------------------
        echo $k
        ssh-add $k
    done
}

#-------------------------------------------------------------------------------
# START MAIN
#-------------------------------------------------------------------------------

# check if SA_FILE exists
if [ -f "$SA_FILE" ]; then
    # source SA_FILE
    . $SA_FILE

    if ps -h -f -p $SSH_AGENT_PID && [ -e "$SSH_AUTH_SOCK" ]; then
        # if keys have expired, add them
        if ! ssh-add -l; then
            for k in $KEY_FILES
            do
                echo --------------------
                echo $k
                ssh-add $k
            done
        fi
    else
        create_ssh_agent
    fi
else
    create_ssh_agent
fi
