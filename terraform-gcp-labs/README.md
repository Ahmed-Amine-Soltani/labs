# Google Cloud Network Concepts

The Power of the Network 
* Simply put, Google has one of the most powerful and robust networking infrastructures on the planet.
*  It is necessary to support their own apps (multiple apps with 1 billion+ users each). 
*  The same network that powers Google also powers our GCP resources. 


![google-apps](../.images/google-apps.png)

Breaking the Network Down 
* Regions
* Zones
* Edge Points of Presence (POP) 


## Regions
* Independent geographic areas that host GCP data centers.
 * At the moment, 22 regions are available worldwide, and growing.
 * Typically consists of 3 or more Danes.
 *  Examples: us-centrall, europe-west4, asia-east2 

![gcp-regions](../.images/gcp-regions.png)

## Zones
* Deployment areas for GCP resources within a region. Multiple individual data center buildings in the geographical region. 
* Typically 3 or more per region. 
* Considered a "single resource failure domain." For fault tolerance, it is best to deploy applications across multiple zones (and regions, where applicable). 
* Examples: us-centrall -a, us-centrall -b, asia-east2-a 

![gcp-zones](../.images/gcp-zones.png)

## Edge Point of Presence (POP)
* Where Google's network connects to the rest of the Internet. • 'Interconnects with other networks"
* Over 130 exchange points exist around the world. 

![gcp-pop](../.images/gcp-pop.png)

Important : 
* Regions by default communicate with each other over google private network.
* Zone is considered a “single failure domain” so for fault tolerance it’s best to deploy across multiple zones.



* GCP network is global in scope, and the defauk mode of operations. 
* All traffic between regions (and within POP network) is on Google's private network 
    * i.e., a global private network (never touches the public Internet)
    * Result: better security, routing, and performance.
* GCP networking resources privately communicate all over the world by default. 


# Virtual Private Cloud (VPC)

### Big Picture Facts 
* Central foundation of all other networking functions on GCP 
* VPC = Software Defined Network (SDN) Traditional network = multiple hardware components (routers, servers, switches, load balancers, firewall devices, device configurations, etc.) Hardware management is abstracted away Removes maintenance and overhead Rapidly customize and scale services Traditional networking concepts apply 
* Firewalls, routes, load balancing, subnets, DNS, etc. 
* Global (multi-regional) communications space, private communication among resources 
    * RFC 1918 - Private (internal) networking and IP addressing standard 
    * Internal/Private IP addressing — not exposed to public Internet 
* Hybrid networking with on-premises networks that have interconnect options 
* Can configure private (internal-only) access to other GCP resources 
* Incoming (ingress) traffic is free and outgoing (egress) traffic has a cost 

### Example VPC Diagram (Hybrid Network)ing)

![gcp-vpc-diagram](../.images/gcp-example-vpc-diagram.png)


## VPCs and Projects

* Projects:
    * Primary resource and billing isolation construct
    * Hold one or more VPCs per project VPC exists within a single project (with shared VPCs being an exception)
    * By default, can have up to five separate VPCs per project (is increased via quota management)
*  Projects separate users, whereas VPCs separate systems 


![gcp-vpc-separation](../.images/gcp-vpc-separation.png)


# Subnets

## Subnets on GCP VPCs 
* VPCs do not come with an associated IP range (must create subnets) 
* Subnet = a logical network partition 
    * Private IP ranges
        * RFC 1918 private IP ranges (10.x.x.x/172.16.x.x/192.168.x.x)
    * Multiple "subnetworks" inside of a larger single network
    * Subitthl = dividing network address space to match an organization's internal network needs
    * On GCP — designated using CIDR notation for network/host division
        * Example: 'subnet-a'. 10.0.1.0/10 



## VPC Structure - Subnets/IP ranges 
* VPC can have one or more subnets 
* Subnet = region based 
    * Subnet can span zones in same region 


![gcp-vpc-structure-subnets-ip-ranges](../.images/gcp-vpc-structure-subnets-ip-ranges.png)

## GCP Subnet Modes 
* Default Auto Mode, Custom 
* Default = created with every new GCP Project 
    * Auto-mode network + pre-made firewall rules
* Auto Mode Network = automatically created subnet for each region
    * One subnet for every region
        * Subnet range of 10.x.x.x/20 per region
        * Get up and working quickly 
    * Can manually add additional subnets or convert to custom mode 
    * Why use auto mode
        * Easy to set up and use
        * Predefined IP ranges dont overlap with each other 
    * Why not to use auto mode 
        * Not as flexible as custom mode
        * Dont need subnet for each region
        * Connecting two different VPCs (VPN/network peering)= overlapping subnets
        * Often not suitable for production networks
* Custom Mode Network  
    * No subnets automatically created -"blank slate" 
    * Much more flexible 
    * "Build your Own Network"
* VPC mode conversions - one way only 
    * Can covert auto mode to custom mode, but not vice versa 



## Reserved IP Addresses 
* Like traditional networks, subnets have the first and last two IVs in range reserved
* First network address
* Second: default gateway
* Second to last future use address
* Last broadcast address 


![gcp-subnets-reserved-ip-addresses](../.images/gcp-subnets-reserved-ip-addresses.png)

