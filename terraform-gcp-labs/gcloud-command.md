

![Anatomy of gcloud command](../.images/Anatomy-of-gcloud-command.png)

GCP Command lines

To create a vpc

gcloud compute networks subnets create my-subnet-1 --network=vpc-3 --region=europe-west1 --range=10.0.1.0/24

To create a subnet
gcloud  compute networks subnets create my-subnet-2 --network=vpc-3 --region=europe-west1 --range=10.0.1.0/24

To reserve external ip addresse
gcloud compute addresses create my-external-ip --region=europe-west1