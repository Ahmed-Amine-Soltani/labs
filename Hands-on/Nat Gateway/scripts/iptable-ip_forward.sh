#!/bin/bash

sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o $(paste <(ip -o -br link) <(ip -o -br addr) | awk '$2=="UP" {print $1}') -j MASQUERADE