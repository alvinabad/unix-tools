# Encrypt a file

```
openssl enc -aes-256-cbc -pbkdf2 -iter 100000 -e -in file.gz > file.gz.enc
openssl enc -aes-256-cbc -pbkdf2 -iter 100000 -d -in file.gz.enc > file.gz
```
