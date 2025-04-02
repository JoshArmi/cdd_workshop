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
