package k8s

import (
	"bytes"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"os/exec"
	"strings"
)

func run(cmd *exec.Cmd) error {
	stderr := &bytes.Buffer{}
	cmd.Stderr = stderr
	if err := cmd.Run(); err != nil {
		cmdStr := cmd.Path + " " + strings.Join(cmd.Args, " ")
		if stderr.Len() == 0 {
			return fmt.Errorf("%s: %v", cmdStr, err)
		}
		return fmt.Errorf("%s %v: %s", cmdStr, err, stderr.Bytes())
	}
	return nil
}

func kubeconfigPath(m interface{}) (string, func(), error) {
	kubeconfig := m.(*config).kubeconfig
	kubeconfigContent := m.(*config).kubeconfigContent
	var cleanupFunc = func() {}

	if kubeconfig != "" && kubeconfigContent != "" {
		return kubeconfig, cleanupFunc, fmt.Errorf("both kubeconfig and kubeconfig_content are defined, " +
			"please use only one of the paramters")
	} else if kubeconfigContent != "" {
		tmpfile, err := ioutil.TempFile("", "kubeconfig_")
		if err != nil {
			defer cleanupFunc()
			return "", cleanupFunc, fmt.Errorf("creating a kubeconfig file: %v", err)
		}

		cleanupFunc = func() {
			var err = os.Remove(tmpfile.Name())
			if err != nil {
				fmt.Errorf("removing temp kubeconfig file: %v", err)
			}
		}

		if _, err = io.WriteString(tmpfile, kubeconfigContent); err != nil {
			defer cleanupFunc()
			return "", cleanupFunc, fmt.Errorf("writing kubeconfig to file: %v", err)
		}
		if err = tmpfile.Close(); err != nil {
			defer cleanupFunc()
			return "", cleanupFunc, fmt.Errorf("completion of write to kubeconfig file: %v", err)
		}

		kubeconfig = tmpfile.Name()
	}

	if kubeconfig != "" {
		return kubeconfig, cleanupFunc, nil
	}

	return "", cleanupFunc, nil
}

func kubectl(m interface{}, kubeconfig string, args ...string) *exec.Cmd {
	if kubeconfig != "" {
		args = append([]string{"--kubeconfig", kubeconfig}, args...)
	}

	context := m.(*config).kubeconfigContext
	if context != "" {
		args = append([]string{"--context", context}, args...)
	}

	return exec.Command("kubectl", args...)
}
