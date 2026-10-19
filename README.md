# slate

TODO: Write a description here
This is a project written using [Lucky](https://luckyframework.org). Enjoy!


## Installation

TODO: Write installation instructions here

## Usage

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Setting up the project
> See  [Install required dependencies](https://luckyframework.org/guides/getting-started/installing#install-required-dependencies) for reference.

### Install prerequisites
1. mise use -g crystal
1. git clone https://github.com/luckyframework/lucky_cli.git
2. shards install --without-development
3. shards build --production
4. cp bin/luck_cli ~/bin/
1. mise use -g bun
1. shards install
1. bun install 
2. bun run build
1. Create a .env file with details that match those in docker-compose.yml
    DB_HOST=127.0.0.1
    DB_PORT=6543
    DB_USERNAME=lucky
    DB_PASSWORD=password
1. docker compose up -d postgres
1. crystal script/setup.cr
2. lucky dev

## Contributing

1. Fork it (<https://github.com/lowkeyliesmyth/slate/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [lowkey](https://github.com/lowkeyliesmyth) - creator and maintainer
