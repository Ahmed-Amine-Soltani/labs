apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  namespace: monitoring
  labels:
    prometheus: kube-prometheus-stack-prometheus
    role: alert-rules
  name: custom-rules-io
spec:
  groups:
   - name: load-balancer.rules
     rules:
     - alert: ahmed_app_pfe
       annotations:
         description: '{{$labels.instance}} - [prod] Current active server = {{ $value }}'
         summary: '{{$labels.instance}} - [prod] HAProxy - backend server(s) down'
       expr: haproxy_backend_current_server{backend="${haproxy_backend}"} < 1
       labels:
         severity: critical