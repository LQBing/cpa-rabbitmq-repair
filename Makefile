IMAGE = lqbing/cpa-rabbitmq-repair:latest

default:
	@echo "=============Building============="
	CGO_ENABLED=0 GOOS=linux go build -o dist/cpa-rabbitmq-repair

docker: default
	@echo "=============Building docker images============="
	docker build -t $(IMAGE) .
