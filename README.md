# MyApp
This project uses Docker and friends!


## Get application dependencies
  1. To get all Docker images and run the application inside docker session, issue the following command
  ```
  docker compose run dev
  ```
  1. Once inside Docker container interaction Bash session, issue the following command:
  ```
  mix local.hex --force && mix setup --force
  ```
  1. To run tests, issue the following command:
  ```
  mix test
  ```

## Get application server up-n-running
  1. To run application server inside Docker container, issue the following command:
  ```
  docker compose up web
  ```
  1. To stop application server, press `<CTRL`-`C>`.
  1. To wrap up, issue the following command:
  ```
  docker compose down
  ```

### Test application
Once application server is up, use Bash scripts in the `./scripts` directory like follows:

    scripts/jobs_resolve_valid.bash
    scripts/jobs_convert_valid.bash

