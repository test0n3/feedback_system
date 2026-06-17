# Feedback system

## Details

- Ruby Version: 3.4.9
- Sinatra: 4.2.1
- SQLite3: 3.46.1

## Development configuration

[Devcontainers]() use is recomended. Use is possible with [VSCode]() and [Rubymine]().
Don't forget to run:

```console
bundle install
bundle exec rake db:create db:migrate
```

to execute, be it with *devcontainer* or without it, run:

```console
foreman start -f Procfile.dev
```

### Content of `.env`

```
RACK_ENV=development
```
