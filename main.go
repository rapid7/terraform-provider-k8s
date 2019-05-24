package main

import (
	"github.com/hashicorp/terraform/plugin"
	"github.com/rapid7/terraform-provider-k8s/k8s"
)

func main() {
	plugin.Serve(&plugin.ServeOpts{ProviderFunc: k8s.Provider})
}
