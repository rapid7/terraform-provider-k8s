package k8s

import (
	"github.com/hashicorp/terraform/helper/schema"
	"github.com/hashicorp/terraform/terraform"
)

func Provider() terraform.ResourceProvider {
	return &schema.Provider{
		Schema: map[string]*schema.Schema{
			"kubeconfig": {
				Type:     schema.TypeString,
				Optional: true,
			},
			"kubeconfig_content": {
				Type:     schema.TypeString,
				Optional: true,
			},
			"kubeconfig_context": {
				Type:     schema.TypeString,
				Optional: true,
			},
		},
		ResourcesMap: map[string]*schema.Resource{
			"k8s_manifest": resourceManifest(),
		},
		ConfigureFunc: providerConfigure,
	}
}

func providerConfigure(d *schema.ResourceData) (interface{}, error) {
	return &config{
		kubeconfig:        d.Get("kubeconfig").(string),
		kubeconfigContent: d.Get("kubeconfig_content").(string),
		kubeconfigContext: d.Get("kubeconfig_context").(string),
	}, nil
}

func resourceManifest() *schema.Resource {
	return &schema.Resource{
		Create: resourceManifestCreate,
		Read:   resourceManifestRead,
		Update: resourceManifestUpdate,
		Delete: resourceManifestDelete,

		Schema: map[string]*schema.Schema{
			"content": {
				Type:     schema.TypeString,
				Required: true,
			},
		},
	}
}
