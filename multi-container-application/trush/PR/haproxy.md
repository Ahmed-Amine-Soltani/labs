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
  user admin  password ASYRtiLFCipT6              groups is-admin
```

Create ACL rule inside ***backend*** (in our case inside frontend stats) section that will allow every user defined in specified userlist.

```cfg
listen stats
  [..]
  acl draw-auth http_auth(basic-auth-list)
  http-request auth realm draw unless draw-aut
```

source: [link](https://sleeplessbeastie.eu/2018/03/08/how-to-define-basic-authentication-on-haproxy/)

**or**

```
listen stats
  [..]
  stats auth admin:password
```



##### HAProxy Stats over HTTPS

to create the pem certificate

```shell
openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem
cat key.pem >> cert.pem
rm key.pem
mkdir -p /etc/haproxy/cert
mv cert.pem /etc/haproxy/cert
```

enable ssl option and add the path to the certificate

```cfg
frontend stats
  bind :9000 ssl crt /etc/haproxy/cert/cert.pem
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

infra cluster Cloud Nat address :  **34.77.226.50**

**or**

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



#### Enabling DDoS Attack Protection 

recorde the number of requests per 10 seconds

```
# Backend for per_ip_rates
backend per_ip_rates
  stick-table type ip size 1m expire 10m store http_req_rate(10s)
```



```cfg
frontend myfrontend
# that ligne going to geed the connection data (track the connections) to the per_ip_rates table in the backend
  http-request track-sc0 src table per_ip_rates
# this gonna start denying requests with and https 439 too many requests response when the counters in the stick table are over 10 requests per second
# we are tracking 10 seconds so 100 requests in 10 seconds is 10 requests per second
  http-request deny deny_status 429 if { sc_http_req_rate(0) gt 100 }  
# to block requests for agents reporting as curl
  http-request deny deny_status 500 if { req.hdr(user-agent) -i -m sub curl }
# to block requests per ip added in /etc/haproxy/blocked.acl
  http-request deny deny_status 503 if { src -f /etc/haproxy/blocked.acl }
```

