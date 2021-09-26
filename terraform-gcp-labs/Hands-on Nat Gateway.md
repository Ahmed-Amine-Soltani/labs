



# Hands-on Nat Gateway



<p align="center"> <img  src="../diagrams/nat-gateway-example.drawio.png" /> </p>



### Solution Number One ( Using virtual machine to act as a NAT gateway)

Create a VPC network to host your virtual machine instances for this scenario

```bash
gcloud compute networks create vpc-io-lab --subnet-mode custom
```



Create subnet for the `europe-west1` region:

```bash
gcloud compute networks subnets create subnet-europe-west1 \
	--network vpc-io-lab \
	--region europe-west1 \
	--range 10.1.0.0/24
```



Create firewall rules to allow SSH connections in the new network you just created

```bash
gcloud compute firewall-rules create vpc-io-lab-allow-ssh \
	--direction=INGRESS \
	--priority=1000 \
	--network=vpc-io-lab \
	--action=ALLOW \
	--rules=tcp:22 \
	--source-ranges=0.0.0.0/0
```

Create firewall rules to allow internal communication inside the network

```bash
gcloud compute firewall-rules create vpc-io-lab-allow-internal-traffic \
    --direction=INGRESS \
    --priority=1000 \
    --network=vpc-io-lab \
    --action=ALLOW \
    --rules=all \
    --source-ranges=10.1.0.0/24
```



Create a virtual machine to act as a NAT gateway on `vpc-io-lab`

```bash
gcloud compute instances create nat-gateway --network vpc-io-lab \
    --subnet subnet-europe-west1 \
    --machine-type e2-micro \
    --image-project=ubuntu-os-cloud \
    --image-family=ubuntu-1804-lts \
    --can-ip-forward \
    --zone europe-west1-b
```

On your NAT gateway instance, configure **iptables** , we can use the command `paste`  get interface name, and you must enable the **IP forwarding** using `net.ipv4.ip_forward`

```bash
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o $(paste <(ip -o -br link) <(ip -o -br addr) | awk '$2=="UP" {print $1}') -j MASQUERADE
```



Create a new virtual machine without an external IP address

```bash
gcloud compute instances create private-instance --network vpc-io-lab \
    --subnet subnet-europe-west1 \
    --machine-type e2-micro \
    --image-project=ubuntu-os-cloud \
    --image-family=ubuntu-1804-lts \
    --no-address \
    --zone europe-west1-b \
    --tags instance-without-external-ip
```



Create a route to send traffic destined to the internet through your gateway instance

```bash
gcloud compute routes create nat-route \
    --network vpc-io-lab \
    --destination-range 0.0.0.0/0 \
    --next-hop-instance nat-gateway \
    --next-hop-instance-zone europe-west1-b \
    --tags instance-without-external-ip \
    --priority 900
```

PS : priority must be higher than the default INTERNET gateway route which is 1000



##### Demonstration 

Virtual machines created

<p align="center"> <img  src="../.images/gcp-nat-gatewat-vms-demostration.png" /> </p>

Nat Gateway ip address

<p align="center"> <img  src="../.images/gcp-nat-gatewat-vm-ip.png" /> </p>

Private instance connectivity and ip address

<p align="center"> <img  src="../.images/gcp-nat-gatewat-private-instaces-demostration.png" /> </p>



### Solution Number Two (Using Cloud NAT & Cloud Router)

<p align="center"> <img  src="../diagrams/cloud-nat-example.drawio.png" /> </p>

Create a VPC network to host your virtual machine instances for this scenario

```bash
gcloud compute networks create vpc-io-lab --subnet-mode custom
```



Create subnet for the `europe-west1` region:

```bash
gcloud compute networks subnets create subnet-europe-west1 \
	--network vpc-io-lab \
	--region europe-west1 \
	--range 10.1.0.0/24
```



Create firewall rules to allow SSH connections in the new network you just created

```bash
gcloud compute firewall-rules create vpc-io-lab-allow-ssh \
	--direction=INGRESS \
	--priority=1000 \
	--network=vpc-io-lab \
	--action=ALLOW \
	--rules=tcp:22 \
	--source-ranges=0.0.0.0/0
```

Create a new virtual machine without an external IP address

```bash
gcloud compute instances create private-instance --network vpc-io-lab \
    --subnet subnet-europe-west1 \
    --machine-type e2-micro \
    --image-project=ubuntu-os-cloud \
    --image-family=ubuntu-1804-lts \
    --no-address \
    --zone europe-west1-b \
    --tags instance-without-external-ip
```



Create a Cloud Router

```bash
gcloud compute routers create nat-router --network=vpc-io-lab \
	--region=europe-west1
```

Create a Cloud NAT

```bash
gcloud compute routers nats create nat-1 \
	--router=nat-router \
	--auto-allocate-nat-external-ips \
	--nat-all-subnet-ip-ranges \
	--enable-logging
```



##### Demonstration 

Virtual machines created

<p align="center"> <img  src="../.images/gcp-nat-gatewat-Cloud-nat-vms-demostration.png" /> </p>

Coud NAT created

<p align="center"> <img  src="../.images/gcp-nat-gatewat-Cloud-Nat-vms-demostration.png" /> </p>



Details on Nat translation request (the `curl` request)

```json
{
  "insertId": "1v5avp3g6skg5cq",
  "jsonPayload": {
    "vpc": {
      "subnetwork_name": "subnet-europe-west1",
      "vpc_name": "vpc-io-lab",
      "project_id": "innovorder-lab"
    },
    "connection": {
      "nat_ip": "34.140.47.0",
      "src_port": 48678,
      "nat_port": 1024,
      "dest_port": 80,
      "protocol": 6,
      "src_ip": "10.1.0.2",
      "dest_ip": "104.21.192.109"
    },
    "endpoint": {
      "zone": "europe-west1-b",
      "project_id": "innovorder-lab",
      "region": "europe-west1",
      "vm_name": "private-instance"
    },
    "gateway_identifiers": {
      "region": "europe-west1",
      "gateway_name": "nat-1",
      "router_name": "nat-router"
    },
    "destination": {
      "geo_location": {
        "country": "usa",
        "asn": 13335,
        "continent": "America"
      }
    },
    "allocation_status": "OK"
  },
  "resource": {
    "type": "nat_gateway",
    "labels": {
      "region": "europe-west1",
      "gateway_name": "nat-1",
      "router_id": "917582447040607864",
      "project_id": "innovorder-lab"
    }
  },
  "timestamp": "2021-09-26T15:09:44.400950463Z",
  "labels": {
    "nat.googleapis.com/instance_zone": "europe-west1-b",
    "nat.googleapis.com/network_name": "vpc-io-lab",
    "nat.googleapis.com/subnetwork_name": "subnet-europe-west1",
    "nat.googleapis.com/router_name": "nat-router",
    "nat.googleapis.com/instance_name": "private-instance",
    "nat.googleapis.com/nat_ip": "34.140.47.0"
  },
  "logName": "projects/innovorder-lab/logs/compute.googleapis.com%2Fnat_flows",
  "receiveTimestamp": "2021-09-26T15:09:47.831000045Z"
}
```

