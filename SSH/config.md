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

# Check sshd server ciphers
```
nmap --script ssh2-enum-algos -sV -p 22 ipaddress
```
