##### postgres

```bash
helm repo add ahmed-postgres https://ahmed-amine-soltani.github.io/labs/multi-container-application/helm/helm-chart/postgres
```
```bash
helm install postgres --set username=postgres-username --set  password=postgres-password ahmed-postgres/multi-container-postgres
```

##### redis

```bash
helm install redis ahmed-redis/multi-container-redis
```

##### client

```bash
helm install client ahmed-client/multi-container-client
```

##### server

env-values.yaml

```yaml
env:
   - name: REDIS_HOST
     value: redis-service 
   - name: REDIS_PORT
     value: 6379
   - name: PGHOST
     value: postgres-service
   - name: PGPORT
     value: 5432
   - name: PGDATABASE
     value: postgres
```

```bash
helm install server -f env-values.yaml ahmed-server/multi-container-server 
```

##### worker

env-values.yaml

```yaml
env:
  - name: REDIS_HOST
    value: redis-service
  - name: REDIS_PORT
    value: 6379
```

```bash
helm install worker -f env-values.yaml ahmed-worker/multi-container-worker
```



##### helm list

```bash
helm list
NAME            NAMESPACE       REVISION        UPDATED                                         STATUS          CHART                           APP VERSION
client          lab             1               2021-10-15 15:35:32.371548808 +0200 CEST        deployed        multi-container-client-0.1.0                   
postgres        lab             1               2021-10-15 15:31:29.796771472 +0200 CEST        deployed        multi-container-postgres-0.1.0             
redis           lab             1               2021-10-15 15:35:55.214034663 +0200 CEST        deployed        multi-container-redis-0.1.0                
server          lab             1               2021-10-15 15:36:32.356204146 +0200 CEST        deployed        multi-container-server-0.1.0               
worker          lab             1               2021-10-15 15:43:12.929562383 +0200 CEST        deployed        multi-container-worker-0.1.0 
```

