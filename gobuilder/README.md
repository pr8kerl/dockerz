# gobuilder

Multi arch build, push...

```
docker login
docker buildx bake --push --set base.platform=linux/amd64,linux/arm64 -f docker-compose.yaml
```
