.PHONY: build run clean network

# Create Docker network if it doesn't exist
network:
	docker network inspect specmatic >/dev/null 2>&1 || docker network create specmatic

# Build the Docker image
build:
	docker build -t springboot-demo .

# Run the container on port 3000
run:
	docker rm -f api 2>/dev/null || true
	docker run -p 3000:8080 --network specmatic --name api springboot-demo

# Clean up Docker resources
clean:
	docker system prune -f

# Build and run in one command
up: network build run

# Stop all running containers
down:
	docker stop $$(docker ps -q --filter ancestor=springboot-demo)

contract-test:
	docker run --network specmatic -v "$$(pwd)/service.yaml:/service.yaml" znsio/specmatic test "/service.yaml" --testBaseURL=http://api:8080

generate-examples:
	docker run -v "$$(pwd)/service.yaml:/usr/src/app/service.yaml" -v "$$(pwd)/service_examples:/usr/src/app/service_examples" znsio/specmatic-openapi examples generate service.yaml

contract-test-examples:
	docker run --network specmatic -v "$$(pwd)/service.yaml:/service.yaml" -v "$$(pwd)/service_examples:/service_examples" znsio/specmatic test "/service.yaml" --testBaseURL=http://api:8080

generative-test:
	docker run --network specmatic -v "$$(pwd)/service.yaml:/service.yaml" -v "$$(pwd)/service_examples:/service_examples" -e SPECMATIC_GENERATIVE_TESTS=true znsio/specmatic test "/service.yaml" --testBaseURL=http://api:8080

stub:
	docker run -p 9000:9000 -v "${PWD}/service.yaml:/usr/src/app/service.yaml" -v "$$(pwd)/service_examples:/service_examples" -v "${PWD}/specmatic.yaml:/usr/src/app/specmatic.yaml" znsio/specmatic stub

strict-stub:
	docker run -p 9000:9000 -v "${PWD}/service.yaml:/usr/src/app/service.yaml" -v "$$(pwd)/service_examples:/service_examples" -v "${PWD}/specmatic.yaml:/usr/src/app/specmatic.yaml" znsio/specmatic stub --strict

compare:
	docker run -v "$$(pwd)/service.yaml:/usr/src/app/service.yaml" -v "$$(pwd)/service_v2.yaml:/usr/src/app/service_v2.yaml" znsio/specmatic compare service.yaml service_v2.yaml

compare-v2:
	docker run -v "$$(pwd)/service_v3.yaml:/usr/src/app/service_v3.yaml" -v "$$(pwd)/service_v2.yaml:/usr/src/app/service_v2.yaml" znsio/specmatic compare service_v2.yaml service_v3.yaml
