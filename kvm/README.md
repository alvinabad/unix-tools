## Install packages
```
sudo apt install -y \
    cpu-checker \
    qemu qemu-kvm \
    libvirt-daemon libvirt-clients \
    bridge-utils virt-manager \

```

## Check number of CPU cores
```
egrep -c '(vmx|svm)' /proc/cpuinfo
```

## Check KVM
```
sudo kvm-ok

INFO: /dev/kvm exists
KVM acceleration can be used
```

## Enable libvirtd
```
sudo systemctl enable --now libvirtd
```

## Enable ipv4 forwarding

Update /etc/sysctl.conf
```
net.ipv4.ip_forward=1
```

## Enable port forwarding

### Create qemu script
/etc/libvirt/hooks/qemu
```
#!/bin/bash

# IMPORTANT: Change the "VM NAME" string to match your actual VM Name.
# In order to create rules to other VMs, just duplicate the below block and configure
# it accordingly.
if [ "${1}" = "VM NAME" ]; then

   # Update the following variables to fit your setup
   GUEST_IP=
   GUEST_PORT=
   HOST_PORT=

   if [ "${2}" = "stopped" ] || [ "${2}" = "reconnect" ]; then
    /sbin/iptables -D FORWARD -o virbr0 -p tcp -d $GUEST_IP --dport $GUEST_PORT -j ACCEPT
    /sbin/iptables -t nat -D PREROUTING -p tcp --dport $HOST_PORT -j DNAT --to $GUEST_IP:$GUEST_PORT
   fi
   if [ "${2}" = "start" ] || [ "${2}" = "reconnect" ]; then
    /sbin/iptables -I FORWARD -o virbr0 -p tcp -d $GUEST_IP --dport $GUEST_PORT -j ACCEPT
    /sbin/iptables -t nat -I PREROUTING -p tcp --dport $HOST_PORT -j DNAT --to $GUEST_IP:$GUEST_PORT
   fi
fi
```

### Set executable
```
sudo chmod +x /etc/libvirt/hooks/qemu
```

### Restart libvirtd
```
sudo systemctl restart libvirtd
```

### Restart Guest
```
sudo virsh reboot guestname
```

