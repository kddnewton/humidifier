package main

import (
	"fmt"
	"github.com/google/go-github/github"
	"golang.org/x/oauth2"
	"net/http"
	"os"
	"os/exec"
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
	http.HandleFunc("/check", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, check())
	})
	http.ListenAndServe(":"+port, nil)
}

func check() string {
	runCommand("git", "clone", "https://"+os.Getenv("GITHUB_TOKEN")+"@github.com/localytics/humidifier.git")
	defer os.RemoveAll("./humidifier")

	os.Chdir("humidifier")
	defer os.Chdir("..")

	runCommand("bundle", "exec", "rake", "specs")
	out := runCommand("git", "status", "--short")

	if out != "" {
		timestamp := time.Now().Format("2006-01-02")
		branchName := "updating-specs-to-" + timestamp
		commitMessage := "Updating specs to " + timestamp

		commitAndPush(branchName, commitMessage)
		openPR(branchName, commitMessage)
		return "Opened PR for " + branchName
	}

	return "No changes"
}

func commitAndPush(branchName string, commitMessage string) {
	runCommand("git", "checkout", "-b", branchName)
	runCommand("git", "add", ".")
	runCommand("git", "commit", "-m", commitMessage)
	runCommand("git", "push", "origin", branchName)
}

func githubClient() *github.Client {
	ts := oauth2.StaticTokenSource(
		&oauth2.Token{AccessToken: os.Getenv("GITHUB_TOKEN")},
	)
	return github.NewClient(oauth2.NewClient(oauth2.NoContext, ts))
}

func openPR(branchName string, commitMessage string) {
	newPR := github.NewPullRequest{Title: &commitMessage, Head: &branchName, Base: github.String("master")}
	_, _, err := githubClient().PullRequests.Create("localytics", "humidifier", &newPR)
	if err != nil {
		panic(err)
	}
}

func runCommand(name string, arg ...string) string {
	out, err := exec.Command(name, arg...).Output()
	if err != nil {
		fmt.Printf("Failing because of " + name + " command")
		panic(err)
	}
	return string(out)
}
