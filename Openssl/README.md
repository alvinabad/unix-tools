# Tools and tips

## Get Server Certificates
```
echo | openssl s_client -showcerts -servername www.google.com -connect www.google.com:443'
```

## Check signing
```
echo | openssl s_client -showcerts -servername www.google.com -connect www.google.com:443 | grep 'Verify return code'
```
