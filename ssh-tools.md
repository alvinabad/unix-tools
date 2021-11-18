# SSH Tools

## Create a Socks5 Proxy

```
ssh -v -N -D 127.0.0.1:1080 user@host
```

With interim host1
```
ssh -v -J user@host1 -N -D 127.0.0.1:1080 user@host2
```

## Create Tunnel to connect to from host1 to host2 using a port that is blocked.

```
ssh -v -t -L 127.0.0.1:3389:host2:3389 -N user@host1
```

Using Multiple hops, host1 -> host2 -> host3
```
ssh -v -t -L 127.0.0.1:3389:127.0.0.1:3389 user@host1 \
  ssh -v -t -L 127.0.0.1:3389:host3:3389 -N user@host2
```

## Create Reverse Tunneling, to ssh from host1 -> host2

This is useful if ssh into host2 is blocked.

From host2, ssh to host1
```
ssh -N -T -R2222:localhost:22 user@host1
```

Use -f option to run in the background
```
ssh -f -N -T -R2222:localhost:22 user@host1
```

From host1, you can now ssh to host2 using localhost at port 2222
```
ssh -p 2222 user@localhost
```
