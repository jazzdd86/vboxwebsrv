# Docker vboxwebsrv with ssh key login

This is a minimal [docker](https://www.docker.io) image that allows you to connect to a computer running VirtualBox through SSH and expose its SOAP WebService (vboxwebsrv) on your machine.

This is particularly intended for use with the [jazzdd86/phpVirtualbox](https://github.com/jazzdd86/phpVirtualbox) docker image.

This is a fork of the original [clue/docker-vboxwebsrv](https://github.com/clue/docker-vboxwebsrv) image. It extends the original one with the possibilty to connect to the server via ssh keys authentication.

## Usage with ssh password authentication

The recommended way to run this container looks like this:

```bash
$ docker run -it --name=vbox_websrv_1 --restart=always jazzdd/vboxwebsrv vbox@10.1.2.3
```

This will start an interactive container that will establish a connection to the given host. The host `10.1.2.3` is your computer that VirtualBox is installed on.

To establish an encrypted SSH connection it will likely ask for your password for user `vbox`. This is the user that runs your virtual machines (VMs) and is in the vboxusers group.

Once connected, it will launch a temporary instance of the  `vboxwebsrv` program that comes with VirtualBox. This will be exposed through the SSH tunnel to your docker container and will terminate when your container terminates.

## Usage with ssh key authentication

To avoid typing in your password everytime the container is started, the image provides the possibility to use ssh key authentication.

```bash
$ docker run -it --name=vbox_websrv_1 --restart=always -e USE_KEY=1 jazzdd/vboxwebsrv vbox@10.1.2.3
```

The container creates a public and private key pair. Enter the public key on the servers authorized_keys file and press enter to continue. If all goes well the terminal output will look like follows:

```bash
$ docker run -it --name=vbox_websrv_1 --restart=always -e USE_KEY=1 jazzdd/vboxwebsrv vbox@10.1.2.3
Generating public/private rsa key pair.
Created directory '/root/.ssh'.
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:quFRKZ9JJZdLhJ53+E3KOeIIMzJX2ixjC9PnDA1wb14 root@831b9ec2b59f
The key's randomart image is:
+---[RSA 4096]----+
|       ..        |
|  . . .. .       |
|   o o..=.       |
|    . **E.. .    |
|   ..X+oS+ =     |
|  = %=*+. * .    |
|   Bo%=o . .     |
|   ..++ .        |
|    o            |
+----[SHA256]-----+


Please copy public key to the servers authorized_keys file before continuing:

ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC33SU6pvdVPrc737r7QvBsPSFfa4n4IB3oiJHjF4YqXDp/UvfXhrtWyukZgJpOVQ7sjh414D7ZJCcQYk3jStGlAGlneMVLdTL/zQqMcLa6SDz/Emb46K7ZmiVc8jZ1gCOD3Og2yU+zveNc3ZwtzyKDKDBbLqzNNRHSrLcinstgHmvX12eKgoDBGy/CnLEFi9EGGVcyJTBLUnU3z8CH4UQe5DKCTbs8lAR7L5gBbYIOD0THbrBL7SjAAtzT5+pYBMc/AfhMqJ7ERzQZHVgaWyHE3wrE2D3ZUMrXqEW1Rdr85xoneXlzXTq8anMrM+/O0BSEh6qhLr5KGiFKSYgFhPLhT5+G1Nrgru5BZLl49MOF6H2dSBzO6YfUl0l4U0C+LnMxl7i1ZFlX7YlWaK69fuk4jnxtDjX9RWaGGjP9L782H5Lfh6J0aLaozGOYaKuDSQTNUTBosenoFEmqTvAs0EYnrS/t1xWYYo7xDj2lhUIISc9PSZXOVH8hd+zoDKolaMtbXKTGHLSCHmYE8YkY2P+GwQrD+mHWQGMxF/yjN6u9VJEJUk+VVEZK/KZv4L0YxSC8VmIw9tJ2pxtmOzOSVaKCcc3OwBq38+Y8ELkK0SoY0wwlX2paz2qbKwPFHf7t7rjIl08u07wt2bDwBkSRfcPIkBscQVZ7FQo7eF36fIOZOw== root@831b9ec2b59f


Press [Enter] to contiue...
The authenticity of host '10.1.2.3 (10.1.2.3)' can't be established.
ECDSA key fingerprint is SHA256:EzrzrnsXeziBqnNDlgq8l/tClq6cv6ND7n4JRp2PlSQ.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '10.1.2.3' (ECDSA) to the list of known hosts.
vboxwebsrv(28007): Operation not permitted
Oracle VM VirtualBox web service Version 5.0.14_OSE
(C) 2007-2016 Oracle Corporation
All rights reserved.
VirtualBox web service 5.0.14_OSE r105127 linux.amd64 (Jan 22 2016 00:45:18) release log
00:00:00.000090 main     Log opened 2016-02-17T19:06:14.537093000Z
00:00:00.000092 main     Build Type: release
00:00:00.000095 main     OS Product: Linux
00:00:00.000096 main     OS Release: 4.4.1-2-ARCH
00:00:00.000097 main     OS Version: #1 SMP PREEMPT Wed Feb 3 13:12:33 UTC 2016
00:00:00.000122 main     DMI Product Name:
00:00:00.000131 main     DMI Product Version:
00:00:00.000196 main     Host RAM: 7874MB total, 4278MB available
00:00:00.000200 main     Executable: /usr/lib/virtualbox/vboxwebsrv
00:00:00.000201 main     Process ID: 31150
00:00:00.000203 main     Package type: LINUX_64BITS_GENERIC (OSE)
00:00:00.157930 SQPmp    Socket connection successful: host = default (localhost), port = 5678, master socket = 8
```

### Avoid recreating SSH Keys when recreating the vboxwebsrv container

After creating the key pair for the first time, you can copy the ssh directory from the container to the host file system with:

```bash
$ docker cp vbox_websrv_1:/root/.ssh/ ssh/
```

You can now recreate the container with either a seperate docker volume containing the ssh keys or use the -v flag within your docker run command:

```bash
$ docker run -it --name=vbox_websrv_1 --restart=always -e USE_KEY=1 -v /path/to/ssh:/root/.ssh jazzdd/vboxwebsrv vbox@10.1.2.3 
```

**Caution:**
the ssh folder must contain id_rsa, id_rsa.pub and the known_hosts file - only than the container can be recreated without any further steps 

## Starting phpVirtualBox

Now you can point your phpVirtualBox container to the vboxwebsrv container. Please see [jazzdd86/phpVirtualbox](https://github.com/jazzdd86/phpVirtualbox) for details

## Different SSH Port

You could also use a different SSH Port (default port is 22) by using `-e SSH_PORT=portNumber` environment variable.

## Different remote vboxwebsrv path

You can choose a different path for the remote vboxwebsrv by using `-e VBOXWEBSRVPATH=/path/to/vboxwebsrv` environment variable.

## Docker Compose

A docker compose file could look as follows:

```yml
version: '3'
services:
    vbox_websrv_1:
        container_name: vbox_websrv_1
        restart: always
        volumes:
            - "./ssh:/root/.ssh"
        environment:
            USE_KEY: 1
            SSH_PORT: portNumber
        image: jazzdd/vboxwebsrv
        command: vbox@10.1.2.3
```

The USE_KEY option works only if a ssh keypair was created earlier with described method above.

Both environment variables are optional.
