service:
  type: NodePort
  port: 5000

env:
   - name: REDIS_HOST
     value: 10.159.94.107
   - name: REDIS_PORT
     value: 6379
   - name: PGHOST
     value: database-pfe.cas6eiunvfhz.eu-central-1.rds.amazonaws.com 
   - name: PGPORT
     value: 5432
   - name: PGDATABASE
     value: postgres
   - name: PGUSER
     value: admin123
   - name: PGPASSWORD
     value: ${postgres_password}
