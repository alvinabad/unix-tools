# ~/.ssh/config settings
```
Host *
    ServerAliveInterval 30
    ServerAliveCountMax 5
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking no
    LogLevel ERROR
    PubkeyAcceptedKeyTypes +ssh-rsa
```

Command line equivalent
```
ssh -o PubkeyAcceptedKeyTypes=+ssh-rsa -o StrictHostKeyChecking=no
```
