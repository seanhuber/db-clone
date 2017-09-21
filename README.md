[![Gem Version](https://badge.fury.io/rb/db-clone.svg)](https://badge.fury.io/rb/db-clone)
[![Build Status](https://travis-ci.org/seanhuber/db-clone.svg?branch=master)](https://travis-ci.org/seanhuber/db-clone)
[![Coverage Status](https://coveralls.io/repos/github/seanhuber/db-clone/badge.svg?branch=master)](https://coveralls.io/github/seanhuber/db-clone?branch=master)

# DbClone

![Screenshot](https://cdn.rawgit.com/seanhuber/db-clone/master/screenshot.png)

## Requirements

Ruby >= 2.3

db-clone requires `mysqldump` (for MySQL) and/or `pg_dump` (for PostgreSQL).

## Installation

Add to `gem 'db-clone', '~> 2.0'` to your `Gemfile` and `bundle install`.

## Usage

To clone your `production` database to `development`, run:

```
rake db:clone
```

If you have more database blocks (besides `production` and `development`) defined in `config/database.yml`, you can clone between these databases using DbClone's CLI:

```
rake db:clone[manual]
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/seanhuber/db-clone.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
