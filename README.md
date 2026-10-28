# slate

TODO: Write a description here
This is a project written using [Lucky](https://luckyframework.org). Enjoy!


## Installation

TODO: Write installation instructions here

## Usage

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Host setup and development
> See  [Install required dependencies](https://luckyframework.org/guides/getting-started/installing#install-required-dependencies) for reference.

Slate requires crystal, lucky-cli, and bun. Local development also uses mise, docker-compose, and taskfile installed locally.

### Install prerequisites
1. Install [mise](https://mise.jdx.dev)
2. Install docker-compose however you want. (mise is an option here, too)
2. Install other prereqs via mise

        mise install

3. Install [lucky-cli](https://luckyframework.org/guides/getting-started/installing#install-lucky-cli-manually)

        pushd ~/Downloads
        git clone https://github.com/luckyframework/lucky_cli.git
        cd lucky_cli
        shards install --without-development
        shards build --production
        cp bin/lucky_cli ~/bin/

### Configure
Create or update `.env` with local development-only settings.

```dotenv
DB_HOST=127.0.0.1
DB_PORT=6543
DB_USERNAME=lucky
DB_PASSWORD=password
```

### Setup
Run `task setup`.

This installs dependencies, builds javascript assets, initializes the database and applies required migrations. 

### Optionally enable synthetic identities

```sh
LUCKY_ENV=development SLATE_DEVELOPMENT_ACCESS=true lucky db.seed.synthetic_users
```

### Run
```sh
lucky dev
```

Open the local UI at 'http://127.0.0.1:3000/`.

## Contributing

1. Fork it (<https://github.com/lowkeyliesmyth/slate/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [lowkey](https://github.com/lowkeyliesmyth) - creator and maintainer
