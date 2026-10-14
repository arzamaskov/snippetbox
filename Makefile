APP := snippetbox
BIN := bin/$(APP)

GO ?= go
MYSQL ?= mysql

DB_NAME ?= $(APP)
DB_USER ?= admin
DB_HOST ?= localhost
DB_PORT ?= 3306

.PHONY: help run build test fmt vet tidy clean db check

.DEFAULT_GOAL := help

help: ## Show available commands
	@awk 'BEGIN {FS = ":.*## "} /^[a-zA-Z0-9_-]+:.*## / {printf "  %-12s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

run: ## Run the application (ARGS="...")
	$(GO) run ./cmd/web $(ARGS)

build: ## Build the application
	@mkdir -p $(dir $(BIN))
	$(GO) build -o $(BIN) ./cmd/web

test: ## Run all tests
	$(GO) test ./...

fmt: ## Format Go code
	$(GO) fmt ./...

vet: ## Run static analysis
	$(GO) vet ./...

tidy: ## Tidy module dependencies
	$(GO) mod tidy

check: fmt vet test ## Format, analyze and test

db: ## Connect to MySQL
	$(MYSQL) -h $(DB_HOST) -P $(DB_PORT) -u $(DB_USER) -p $(DB_NAME)

clean: ## Remove build artifacts
	$(RM) -r bin
