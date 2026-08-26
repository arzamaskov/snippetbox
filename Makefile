APP := snippetbox
BIN := bin/$(APP)

.PHONY: help run build test fmt vet tidy clean

help: ## Display available commands
	@awk 'BEGIN {FS = ":.*## "} /^[a-zA-Z0-9_-]+:.*## / {printf "  %-10s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

run: ## Run the application
	@echo "Application is available at: http://localhost:4000"
	go run ./cmd/web

build: ## Build the application binary
	mkdir -p bin
	go build -o $(BIN) ./cmd/web

test: ## Run tests
	go test ./...

fmt: ## Format Go code
	go fmt ./...

vet: ## Run Go static analysis
	go vet ./...

tidy: ## Tidy Go module dependencies
	go mod tidy

clean: ## Remove build artifacts
	rm -rf bin
