# eLearning Platform

## Getting started

Migrate the database:

```
$ rails db:migrate
$ rails db:seed
```

Start the server:

```
$ rails server
```

### Useful commands:

- `eval "$(rbenv init - zsh)"`
- `rbenv install << version | 2.7.5 >>` -> install specific version
- `rbenv global << version | 2.7.5 >>` -> set this version as global
- `gem install bundler:2.2.31` -> install Bundler's specific version
- `bundle _2.2.31_ install` -> install all gems under 2.2.31 Bundler
- `bundle config build.pg --with-pg-config=/Applications/Postgres.app/Contents/Versions/13/bin/pg_config` -> fix PG error on `install`