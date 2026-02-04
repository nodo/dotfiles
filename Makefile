.PHONY: help install test

help:
	@echo "Available targets:"
	@echo "  install  - Run setup script"
	@echo "  test     - Run tests in Docker (Linux)"

install:
	./script/setup

test:
	./script/test.sh
