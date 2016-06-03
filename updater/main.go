package main

import (
	"fmt"
	"github.com/google/go-github/github"
	"golang.org/x/oauth2"
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
		timestamp := time.Now().Format("2006-01-02")
		var branchName = "updating-specs-to-" + timestamp

		commitAndPush(branchName, timestamp)
		openPR(branchName, timestamp)
	}
}

func commitAndPush(branchName string, timestamp string) {
	runCommand("git", "checkout", "-b", branchName)
	runCommand("git", "add", ".")
	runCommand("git", "commit", "-m", "Updating specs to "+timestamp)
	runCommand("git", "push", "origin", branchName)
}

func githubClient() *github.Client {
	ts := oauth2.StaticTokenSource(
		&oauth2.Token{AccessToken: os.Getenv("GITHUB_TOKEN")},
	)
	return github.NewClient(oauth2.NewClient(oauth2.NoContext, ts))
}

func openPR(branchName string, timestamp string) {
	newPR := github.NewPullRequest{Title: github.String("Updating specs to " + timestamp), Head: &branchName, Base: github.String("master")}
	_, _, err := githubClient().PullRequests.Create("localytics", "humidifier", &newPR)
	if err != nil {
		panic(err)
	}
}

func runCommand(name string, arg ...string) string {
	out, err := exec.Command(name, arg...).Output()
	if err != nil {
		panic(err)
	}
	return string(out)
}
