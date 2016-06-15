# Updater

This server periodically (once a day) checks to see if the AWS CloudFormation specs have changed. In the event of a change, it pushes a new branch to the git repository with the changes and opens a new pull request.

## Development

To run the server locally, ensure you have golang and the necessary dependencies installed. Then from the `updater` directory, run:

```
PORT=<port> GITHUB_TOKEN=<token> go run main.go
```

where `<port>` is the port that the server should listen on and `<token>` is a token from github that can read the humidifier repository.
