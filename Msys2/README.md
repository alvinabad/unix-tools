# Download installer
```
https://www.msys2.org/
```

# Install additional packages

```
pacman -S mingw-w64-ucrt-x86_64-gcc
pacman -S mingw-w64-ucrt-x86_64-toolchain
pacman -S openssh
pacman -S git
pacman -S vim
pacman -S procps
pacman -S make
pacman -S mingw-w64-ucrt-x86_64-lld
pacman -S mingw-w64-x86_64-lld
pacman -S mingw-w64-ucrt-x86_64-toolchain
pacman -S tmux
```

# Install and run sshd
```
pacman -S openssh
ssh-keygen -A
/usr/bin/sshd -p 23
```

# Go Settings

# Set up go

Install Go
```
pacman -S mingw-w64-ucrt-x86_64-go
```

Add to $HOME/.bashrc
```
export GOROOT=/ucrt64/lib/go
export GOPATH=/ucrt64
export GOCACHE="$HOME/.cache/go-build"
```

# Set up sshd
```
ssh-keygen -A
```

# Open port 22 and ping
```
netsh advfirewall firewall add rule name="Open SSH Port 22" dir=in action=allow protocol=TCP localport=22 remoteip=any

netsh advfirewall firewall add rule name="Open Ping" dir=in action=allow protocol=icmpv4 remoteip=any
```
