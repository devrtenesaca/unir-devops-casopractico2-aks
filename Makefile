APP_DIR = /app
tag = latest

PHONY: build run clean
build_container:
	docker build -t myapp:latest .