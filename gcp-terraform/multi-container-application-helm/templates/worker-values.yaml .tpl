deployment:
  name: worker-deployment
  component: worker
  replicas: 1
  templateName: worker
  imageName: worker
  image: ahmedaminesoltani/multi-worker:latest

env:
  - name: REDIS_HOST
    value: redis-service
  - name: REDIS_PORT
    value: 6379