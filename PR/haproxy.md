### haproxy modifications

##### to define basic authentication on HAProxy

Install whois package to use mkpassword utility – an overfeatured frontend to the crypt function.

```shell
$ sudo apt-get install whois
```

Generate hashed passwords. You can use *DES*, *MD5*, *SHA-256* or *SHA-512*.

```shell
$ printf "password" | mkpasswd --stdin --method=des
ASYRtiLFCipT6
```

Create user list that describes users and groups.

```cfg
userlist basic-auth-list
  group is-admin                                                                               
  user admin  password kCISOi.HYzx/E                                          groups is-admin
```

Create ACL rule inside ***backend*** (in our case inside frontend stats) section that will allow every user defined in specified userlist.

```cfg
frontend stats
  acl draw-auth http_auth(basic-auth-list)
  http-request auth realm draw unless draw-aut
```

source: [link](https://sleeplessbeastie.eu/2018/03/08/how-to-define-basic-authentication-on-haproxy/)



##### HAProxy Stats over HTTPS

to create the pem certificate

```shell
$ openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem
$ cat key.pem >> cert.pem
$ rm key.pem
$ mkdir -p /etc/haproxy/cert
$ mv cert.pem /etc/haproxy/cert
```

enable ssl option and add the path to the certificate

```cfg
frontend stats
  bind *:9000 ssl crt /etc/haproxy/cert/cert.pem
```

restart haproxy service

```shell
$ systemctl restart haproxy.service
```

##### HAProxy Exporter

we can remove haproxy-exporter, we have already installed it at the k8s (gke-app-infra) cluster level.
