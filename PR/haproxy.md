### haproxy modifications

##### to define basic authentication on HAProxy

Install whois package to use mkpassword utility – an overfeatured frontend to the crypt function.

```shell
sudo apt-get install whois
```

Generate hashed passwords. You can use *DES*, *MD5*, *SHA-256* or *SHA-512*.

```shell
printf "password" | mkpasswd --stdin --method=des
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
listen stats
  [..]
  acl draw-auth http_auth(basic-auth-list)
  http-request auth realm draw unless draw-aut
```

source: [link](https://sleeplessbeastie.eu/2018/03/08/how-to-define-basic-authentication-on-haproxy/)



##### HAProxy Stats over HTTPS

to create the pem certificate

```shell
openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem
cat key.pem >> cert.pem
rm key.pem
mkdir -p /tmp/cert
mv cert.pem /tmp/cert
```

enable ssl option and add the path to the certificate

```cfg
frontend stats
  bind :9000 ssl crt /tmp/cert/cert.pem
  [..]
```



##### Restrict specific URLs to specific IP addresses

you can use public or private IP addresses but also networks in the `src`

```cfg
listen stats
  [..]
  acl white_list src 192.168.1.2/32 192.168.1.3/32
  tcp-request content accept if white_list
  tcp-request content reject
```

or

```
listen stats
  [..]
  acl white_list  src -f /etc/haproxy/whitelist.lst
  tcp-request content accept if white_list
  tcp-request content reject
```

```
cat /etc/haproxy/whitelist.lst
192.168.1.2/32
192.168.1.3/32
```



##### Validating the HAProxy Configuration

```bash
haproxy -c -V -f /etc/haproxy/haproxy.cfg
```



restart haproxy service

```shell
systemctl restart haproxy.service
```



##### HAProxy Exporter

we can remove haproxy-exporter, we have already installed it at the k8s (gke-app-infra) cluster level.
