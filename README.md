# Feedback system

## Details

- Ruby Version: 3.4.9
- Sinatra: 4.2.1
- SQLite3: 3.46.1

## Development configuration

[Devcontainers](https://containers.dev/) use is recommended. Use is possible with [VSCode](https://code.visualstudio.com/) and [Rubymine](https://www.jetbrains.com/ruby/).

Don't forget to run:

```console
bundle install
bundle exec rake db:create db:migrate
pnpm install
pnpm approve-builds
```

To execute, be it with *devcontainer* or without it, run:

```console
foreman start -f Procfile.dev
```

### Content of `.env`

```
RACK_ENV=development
```

## Notes

`enum`s don't work with **rake**, so a constant was defined to manage the status of feedback.

