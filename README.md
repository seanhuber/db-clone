[![Gem Version](https://badge.fury.io/rb/db-clone.svg)](https://badge.fury.io/rb/db-clone)
[![Build Status](https://travis-ci.org/seanhuber/db-clone.svg?branch=master)](https://travis-ci.org/seanhuber/db-clone)
[![Coverage Status](https://coveralls.io/repos/github/seanhuber/db-clone/badge.svg?branch=master)](https://coveralls.io/github/seanhuber/db-clone?branch=master)

# db-clone

The `db-clone` gem provides a rake task for cloning one database into another.  It does this by making a system call to `mysqldump` or `pg_dump` (currently only mysql and postgresql are supported) and uses the contents of your application's `database.yml` to determine the command line arguments.

![Screenshot](https://cdn.rawgit.com/seanhuber/db-clone/master/screenshot.png)

## Requirements

Ruby >= 2.3

db-clone requires `mysqldump` (for MySQL) and/or `pg_dump` (for PostgreSQL).

## Installation

Add `gem 'db-clone', '~> 2.1'` to your `Gemfile` and `bundle install`.

## Usage

To clone your `production` database to `development`, run:

```
rake db:clone
```

If you have more database blocks (besides `production` and `development`) defined in `config/database.yml`, you can clone between these databases using DbClone's CLI:

```
rake db:clone[manual]
```

## Configuration

By default `rake db:clone` will read from `config/database.yml` and use your `production` database as the source and `development` as the destination.  You can configure these defaults to something else by adding to your `Rakefile` (or in an initializer if you're using Rails):

```ruby
Db::Clone.setup do |config|
  # default is 'config/database.yml'
  config.database_yml_path = '/path/to/my_database_config.yml'

  # default is 'production'
  config.default_source_database = 'my_source_db'

  # default is 'development'
  config.default_destination_database = 'my_destination_db'

  # default is [], adds --ignore-table arguments to mysqldump or --exclude-table arguments to pg_dump
  config.ignore_tables = ['schema_migrations', 'some_other_table']
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/seanhuber/db-clone.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
