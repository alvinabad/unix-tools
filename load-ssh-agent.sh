#!/bin/bash

#-------------------------------------------------------------------------------
# Enable ssh-agent
# Usage: Must be sourced to run
# Example:
#     . $HOME/src/unix-tools/load-ssh-agent.sh 72h 
#
# This may be added to ~/.profile or ~/.bash_profile to run upon log in.
#-------------------------------------------------------------------------------

usage() {
    cat <<EOF
Usage:
    load-ssh-agent <expiration>

expiration:
    0           No expiration
    72h         Expire in 72 hours
    120h        Expire in 120 hours
    -k          Terminate existing ssh-agent
EOF
}

# set keyfiles to load
KEY_FILES="${KEY_FILES:=-default}"

SA_DIR=$HOME/.ssh
SA_FILE=${SA_DIR}/sa

# Create an ssh-agent
create_ssh_agent() {
    # killall any ssh-agents and create a new one
    killall ssh-agent || true

    echo "Launching a new ssh-sgent."
    mkdir -p $SA_DIR
    chmod 700 $SA_DIR
    echo "Saving to $SA_FILE"
    ssh-agent -t $SSH_AGENT_EXP > $SA_FILE

    # load ssh-agent info
    echo "Loading ssh-agent..."
    . $SA_FILE

    # load keys to agent
    echo "Loading keys to agent..."
    for key in $KEY_FILES
    do
        #ssh-add -t 72h $HOME/.ssh/$k
        echo ssh-add -t $SSH_AGENT_EXP $key
        ssh-add -t $SSH_AGENT_EXP $key
    done
}

#-------------------------------------------------------------------------------
# START MAIN
#-------------------------------------------------------------------------------

SSH_AGENT_EXP=$1

# if SA_FILE exists, source it
if [ $# -eq 0 ]; then
    usage
elif [ -f "$SA_FILE" ]; then
    # source SA_FILE to get ssh-agent PID
    echo "Found: $SA_FILE loading..."
    . $SA_FILE > /dev/null

    # if ssh-agent is up
    if ps -f -p $SSH_AGENT_PID && [ -e "$SSH_AUTH_SOCK" ]; then
        # if desired to kill agent
        if [ "$SSH_AGENT_EXP" = "-k" ]; then
            echo "Killing ssh-agent..."
            ssh-agent -k
        # if keys have expired, add them
        elif ! ssh-add -l; then
            echo "Keys have expired. Adding to agent..."
            for k in $KEY_FILES
            do
                echo "    $k"
                ssh-add $k
            done
        fi
    # if there is no ssh-agent running, create a new one
    else
        create_ssh_agent
    fi
# if SA file does not exist, create a new ssh-agent
else
    echo "No ssh-agent found."
    if [ "$SSH_AGENT_EXP" = "-k" ]; then
        echo "Killing ssh-agent..."
        ssh-agent -k
    else
        create_ssh_agent
    fi
fi
