# Metadata for driving the build lives here.
META_DIR := .make
SHELL := /usr/bin/env bash
KUBERNETES_DIR := $(CURDIR)/kubernetes
KUBERNETES_OUTPUT_DIR := $(KUBERNETES_DIR)/_output

.PHONY: help check_kubernetes_version build_image

default: help

help:
	@echo "---> Help menu:"
	@echo "supported make targets:"
	@echo ""
	@echo "---"
	@echo ""
	@echo "Help output:"
	@echo "make help"
	@echo ""
	@echo "Clones the kubernetes source code"
	@echo "make get_kubernetes_source"
	@echo ""
	@echo "Builds the kubernetes binaries"
	@echo "make build_kubernetes_binaries"
	@echo ""
	@echo "Builds the docker image artifact containing the kubernetes built binaries"
	@echo "make build_image"
	@echo ""
	@echo "Sends the image artifact to the quay repository"
	@echo "make image_to_quay"
	@echo ""

check_kubernetes_version:
ifndef KUBERNETES_VERSION
	$(error you must tell me the version of kubernetes that you want to build, set the KUBERNETES_VERSION environment variable)
endif

get_kubernetes_source: check_kubernetes_version
	export KUBERNETES_VERSION
	git clone https://github.com/kubernetes/kubernetes.git
	cd $(KUBERNETES_DIR); git checkout $(KUBERNETES_VERSION)

build_kubernetes_binaries: check_kubernetes_version
	cd $(KUBERNETES_DIR); KUBE_GIT_VERSION=$(KUBERNETES_VERSION) make quick-release
	ls -lha $(KUBERNETES_OUTPUT_DIR)
	$(KUBERNETES_OUTPUT_DIR)/dockerized/bin/linux/amd64/kubectl version --client
	$(KUBERNETES_OUTPUT_DIR)/dockerized/bin/linux/amd64/kube-apiserver --version
	$(KUBERNETES_OUTPUT_DIR)/dockerized/bin/linux/amd64/kube-controller-manager --version
	$(KUBERNETES_OUTPUT_DIR)/dockerized/bin/linux/amd64/kube-scheduler --version
	rm -rf $(KUBERNETES_OUTPUT_DIR)/images
	rm -rf $(KUBERNETES_OUTPUT_DIR)/release-stage
	rm -rf $(KUBERNETES_OUTPUT_DIR)/release-tars

build_image: check_kubernetes_version
	docker build -t kubernetes-e2e-binaries --build-arg KUBERNETES_VERSION=$(KUBERNETES_VERSION) .
