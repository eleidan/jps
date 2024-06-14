# MyApp

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## How-To
This project uses Docker and friends!

### Get application server up-n-running
  1. To get all Docker images and run the application, issue the following command:
  ```
  docker compose up web
  ```
  1. To stop application server, press `<CTRL`-`C>`.
  1. To wrap up, issue the following command:
  ```
  docker compose down
  ```

### Test application
Once application server is up, use **Bash** scripts in the `./scripts` directory like follows:

    ```
    scripts/jobs_resolve_valid.bash
    ```
    ```
    scripts/jobs_convert_valid.bash
    ```

