DbClone
==============

![Screenshot](https://cdn.rawgit.com/seanhuber/db-clone/master/screenshot.png)

Requirements
-----------------

Rails >= 4.0 and Ruby >= 2.1.  

DbClone requires `mysqldump` (for MySQL) and/or `pg_dump` (for PostgreSQL).


Installation
-----------------

Add to `gem 'db-clone', require: 'db_clone'` to your `Gemfile` and `bundle install`.



Usage
-----------------

To clone your `production` database to `development`, run:

    rake db:clone

If you have more database blocks (besides `production` and `development`) defined in `config/database.yml`, you can clone between these databases using DbClone's CLI:

    rake db:clone[manual]


License
-----------------

MIT-LICENSE.
