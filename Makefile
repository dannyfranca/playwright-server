.PHONY: build install-quadlet uninstall-quadlet clean

SYSTEMD_DIR := $(HOME)/.config/containers/systemd
SERVICE_NAME := playwright-server
CONTAINER_FILE := $(SERVICE_NAME).container

build:
	podman build -t $(SERVICE_NAME) .

install-quadlet: build
	@echo "Installing Quadlet to $(SYSTEMD_DIR)..."
	mkdir -p $(SYSTEMD_DIR)
	cp $(CONTAINER_FILE) $(SYSTEMD_DIR)/
	systemctl --user daemon-reload
	systemctl --user start $(SERVICE_NAME)
	@echo "Quadlet installed and service started. Status:"
	@systemctl --user status $(SERVICE_NAME) --no-pager

uninstall-quadlet:
	@echo "Uninstalling Quadlet..."
	-systemctl --user stop $(SERVICE_NAME)
	-systemctl --user disable $(SERVICE_NAME)
	rm -f $(SYSTEMD_DIR)/$(CONTAINER_FILE)
	systemctl --user daemon-reload
	@echo "Quadlet uninstalled."

clean:
	rm -rf dist output test-results
