# from-ticket-to-pull-request-exercises

This repository is a companion to the training "From Ticket To Pull Request" and
contains a set of exercises designed to teach Git commit and pull request
workflows. The exercises are built using Docker containers, allowing for a
isolated and safe environment across different systems.

## Installation

1. Clone the repository:

```shell
git clone https://github.com/mikelorant/from-ticket-to-pull-request-exercises.git
```

1. Navigate to the project directory:

```shell
cd from-ticket-to-pull-request-exercises
```

## Usage

1. Pull the required Docker images:

```shell
docker-compose pull
```

1. Run the exercises when prompted by the instructor.

   - Exercise 1

     ```shell
     docker-compose run --rm --service-ports exercise-1
     ```

   - Exercise 2

     ```shell
     docker-compose run --rm --service-ports exercise-2
     ```

You will be asked to enter your name and email address, which will be used for
Git commits. Additionally, you'll be asked to choose your preferred text editor
(nano or vim) during the first run. These settings will be saved for future use.

## Repository Access

The Git repository is accessible via Ngrok [endpoint][1]. A shared account has
been created for testing purposes:

Username: `john.smith@example.com`

Password: `password`

This shared account can be useful for testing or demonstrating scenarios where
multiple users collaborate on the same repository. It has already been
configured in the exercises as a remote, and you should have permissions to push
changes using `git push`.

## Repository Hosting

The project includes a Gitea server hosted within a Docker container, which is
exposed to the internet using Ngrok. Ngrok is a tool that creates secure tunnels
from your local machine to the internet, allowing remote access to locally
hosted services like the Gitea server in this case. The Ngrok HTTP endpoint is
routed through the Docker container to the Gitea server, enabling remote access
to the Git repository.

To start the Gitea server and Ngrok tunnel, run the following command:

```shell
docker-compose up --detach
```

Note: You'll need to provide an Ngrok authentication token in the `.env.ngrok`
file for this to work.

## Dependencies

This project utilizes the following third-party packages:

- [Gitea](https://github.com/go-gitea/gitea) - A painless self-hosted Git
  service
- [Ngrok](https://github.com/ngrok/ngrok) - Secure tunnels to localhost

## License

This project is licensed under the [MIT License](LICENSE).

## Contributing

Contributions are welcome! Please open an issue or submit a pull request if you
have any improvements or bug fixes.

[1]: https://sunbeam-smiling-overly.ngrok-free.app
