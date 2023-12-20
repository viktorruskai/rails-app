# eLearning Platform

## Getting started

Also make sure you’re using a compatible version of Node.js:

```
$ nvm install 16.13.0
$ node -v
v16.13.0
```

Then install the needed packages (while skipping any Ruby gems needed only in production):

```
$ yarn add jquery@3.5.1 bootstrap@3.4.1
$ gem install bundler -v 2.2.17
$ bundle _2.2.17_ config set --local without 'production'
$ bundle _2.2.17_ install
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you’ll be ready to seed the database with sample users and run the app in a local server:

```
$ rails db:seed
$ rails server
```

### Useful commands:

- `eval "$(rbenv init - zsh)"`
- `rbenv install << version | 2.7.5 >>` -> install specific version
- `rbenv global << version | 2.7.5 >>` -> set this version as global
- `gem install bundler:2.2.31` -> install Bundler's specific version
- `bundle _2.2.31_ install` -> install all gems under 2.2.31 Bundler
- `bundle config build.pg --with-pg-config=/Applications/Postgres.app/Contents/Versions/13/bin/pg_config` -> fix PG error on `install`

You can then register a new user or log in as the sample administrative user with the email `example@railstutorial.org` and password `foobar`.