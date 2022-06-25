## Download
```
setup-x86_64.exe
```

## Install without admin rights

Open CMD terminal and run:
```
setup-x86_64.exe --no-admin
```

## Packages to install
```
gcc
make
python
git
openssh
openssl
unzip
zip
xz
```

## Set up Openssh Server

1. Edigt Cygwin.bat
```
set CYGWIN=binmode ntsec
```

2. Run Cygwin.bat

Run Cygwin.bat
```
C:\cygwin\Cygwin.bat
```

3 Run ssh-host-config

```
ssh-host-config
```
*** Query: Should privilege separation be used? <yes/no>: yes
*** Query: New local account 'sshd'? <yes/no>: yes
*** Query: Do you want to install sshd as a service?
*** Query: <Say "no" if it is already installed as a service> <yes/no>: no
*** Query: Enter the value of CYGWIN for the deamon: [] binmode ntsec
*** Query: Do you want to use a different name? (yes/no) no
```

Do not install as a service if you don't admin rights.

4. Set up sshd config
```
+++ /etc/sshd_config	2022-06-25 16:26:11.492135800 -0700
@@ -34,7 +34,7 @@

-#PubkeyAuthentication yes
+PubkeyAuthentication yes

 # To disable tunneled clear text passwords, change to no here!
-#PasswordAuthentication yes
+PasswordAuthentication no
 #PermitEmptyPasswords no

-#UseDNS no
+UseDNS no
```

4. Start SSH daemon

```
/usr/sbin/sshd
```

5. Set up public key

```
~/.ssh/authorized_keys
```

