package main

import (
	"fmt"
	"net/http"
	"os"
	"os/exec"
	"path"
	"time"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" || os.Getenv("GITHUB_TOKEN") == "" {
		panic("Both PORT and GITHUB_TOKEN must be set")
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Running")
	})
	http.HandleFunc("/check", check)
	http.ListenAndServe(":"+port, nil)
}

func check(w http.ResponseWriter, r *http.Request) {
	runCommand("git", "clone", "https://"+os.Getenv("GITHUB_TOKEN")+"@github.com/localytics/humidifier.git")
	defer os.RemoveAll("./humidifier")

	os.Chdir("humidifier")
	defer os.Chdir("..")

	runCommand(path.Join("bin", "get-specs"))
	out := runCommand("git", "status", "--short")

	if out != "" {
		commitAndPush()
	}
}

func commitAndPush() {
	timestamp := time.Now().Format("2006-01-02")
	var branchName = "updating-specs-to-" + timestamp

	runCommand("git", "checkout", "-b", branchName)
	runCommand("git", "add", ".")
	runCommand("git", "commit", "-m", "Updating specs to "+timestamp)
	runCommand("git", "push", "origin", branchName)
}

func runCommand(name string, arg ...string) string {
	out, err := exec.Command(name, arg...).Output()
	if err != nil {
		panic(err)
	}
	return string(out)
}
