



# Hands On

# Create a VPC network to host your virtual machine instances for this scenario





Create a VPC network to host your virtual machine instances for this scenario

```bash
gcloud compute networks create my-network --subnet-mode custom
```



Create subnet for the `europe-west1` region:

```bash
gcloud compute networks subnets create subnet-europe-west1 \
	--network my-network \
	--region europe-west1 \
	--range 10.1.0.0/24
```



Create firewall rules to allow SSH connections in the new network you just created

```bash
gcloud compute firewall-rules create my-network-allow-ssh \
	--direction=INGRESS \
	--priority=1000 \
	--network=my-network \
	--action=ALLOW \
	--rules=tcp:22 \
	--source-ranges=$(curl ifconfig.io)
```

Create firewall rules to allow internal communication inside the network

```bash
gcloud compute firewall-rules create my-network-allow-internal \
    --direction=INGRESS \
    --priority=1000 \
    --network=my-network \
    --action=ALLOW \
    --rules=all \
    --source-ranges=10.1.0.0/24
```



Create a virtual machine to act as a NAT gateway on `my-network`

```bash
gcloud compute instances create nat-gateway --network my-network \
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
gcloud compute instances create private-instance --network my-network \
    --subnet subnet-europe-west1 \
    --machine-type e2-micro \
    --image-project=ubuntu-os-cloud \
    --image-family=ubuntu-1804-lts \
    --no-address \
    --zone europe-west1-b \
    --tags no-ip
```



Create a route to send traffic destined to the internet through your gateway instance

```bash
gcloud compute routes create nat-route \
    --network my-network \
    --destination-range 0.0.0.0/0 \
    --next-hop-instance nat-gateway \
    --next-hop-instance-zone europe-west1-b \
    --tags no-ip \
    --priority 800
```

