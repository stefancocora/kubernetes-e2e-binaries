# kubernetes-e2e-binaries

[![Docker Repository on Quay](https://quay.io/repository/ukhomeofficedigital/kubernetes-e2e-binaries/status "Docker Repository on Quay")](https://quay.io/repository/ukhomeofficedigital/kubernetes-e2e-binaries)

# tldr
If you've seen the readme before and you're after the _tldr_ version of how to build and contribute then go straight to the *Release process* section.

# What is this software and what does it do
The purpose of this repository is to create an immutable artifact with pre-baked and compiled kubernetes binaries for the version of kubernetes that needs to be tested.

The artifact created from this repo can be used to import into a working kubernetes cluster code ( works even for a git checkout of the kubernetes source code with a matching tag ) the kubernetes upstream binaries including the binaries needed for end-to-end testing.

This way you get kubernetes compiled and versioned binaries, without having to wait the long time needed to compile them.
This will save additional time when testing against a kubernetes cluster in your continuous integration software !

# How to use the software
This software is geared to be included by your CI in your custom build steps.

One of your purpose built build steps will need to copy the `_output` kubernetes directory from this image , from the directory `/kubernetes/${KUBERNETES_VERSION}/_output`, into your CI checked out source code.

`KUBERNETES_VERSION` tracks the kubernetes upstream release tags.


# Release process
The release process is done using drone.

## local testing
Apart from the push to the upstream container registry, all the CI build steps can be reproduced on your laptop/workstation.

This makes it easy to test your changes before pushing them to the CI system.

## kubernetes version
To target a specific version of kubernetes you have to change a few things in the repository.
- for the `Makefile` export the KUBERNETES_VERSION environment variable before running any make targets
- the make target `update_kube_version` will update the `.drone.yml` file to the same version as the one set in the exported variable above. In drone you have to setup the kubernetes version multiple times because at this time drone doesn't have support for setting global environment variables.


# Licensing
See `LICENSE.md`

# Raising issues
Use the github issue functionality on this repository to raise issue against this project.

# Contributing
See `CONTRIBUTING.md`
