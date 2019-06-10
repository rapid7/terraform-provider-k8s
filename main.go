package main

import (
	"github.com/hashicorp/terraform/plugin"
	"github.com/rapid7/terraform-provider-k8s/k8s"
)

var (
	version = "dev"
	commit  = "none"
	date    = "unknown"
)

func main() {
	plugin.Serve(&plugin.ServeOpts{ProviderFunc: k8s.Provider})
}
