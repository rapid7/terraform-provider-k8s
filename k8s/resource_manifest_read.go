package k8s

import (
	"bytes"
	"fmt"
	"strings"

	"github.com/hashicorp/terraform/helper/schema"
)

func resourceManifestRead(d *schema.ResourceData, m interface{}) error {
	resource, namespace, ok := resourceFromSelflink(d.Id())
	if !ok {
		return fmt.Errorf("invalid resource id: %s", d.Id())
	}

	args := []string{"get", "--ignore-not-found", resource}
	if namespace != "" {
		args = append(args, "-n", namespace)
	}

	stdout := &bytes.Buffer{}
	kubeconfig, cleanup, err := kubeconfigPath(m)
	if err != nil {
		return fmt.Errorf("determining kubeconfig: %v", err)
	}
	defer cleanup()

	cmd := kubectl(m, kubeconfig, args...)
	cmd.Stdout = stdout
	if err := run(cmd); err != nil {
		return err
	}
	if strings.TrimSpace(stdout.String()) == "" {
		d.SetId("")
	}
	return nil
}
