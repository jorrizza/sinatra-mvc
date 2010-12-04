Sinatra MVC
===========

Sinatra MVC is a simple attempt to get some kind of MVC structure on top
of Sinatra, without losing much of the original Sinatra "feeling". It
uses Datamapper for it's model layer and custom software for the other
two.

A rule of thumb: In command line examples, a `$` prefix means your own
user and a `#` prefix is a root terminal.

System Dependencies
-------------------

Your system needs to have a working Ruby 1.9.2 installation (or later,
but I haven't tested that). You'll also need some kind of database. The
currently supported databases are:

* MySQL
* PostgreSQL
* Sqlite3

Sinatra MVC also has the possibility to use Memcache as a session storage
system. This is the default. It's recommended as well.

The framework has been developed on a Debian Sid platform, and as such
Debian is the preferred platform of choice. If you encounter problems
caused by Debian-specific hacks, please let me know. The interpreter
string has been set to `ruby1.9.1`, but you can easily change that in
`sinatra-mvc.rb` if you wish. Don't worry, that's the only place the 
"weird" interpreter string is used.

Throughout the documentation Debian-specific help will be provided. Other
operating systems might be added later.

Installing
----------

Installing Sinatra MVC is reasonably simple. All you need is Mercurial,
some development headers (distributed by your operating system) and
a terminal.

For Debian users, the following command will suffice (or ask your system
administrator to install the packages for you):

    # apt-get install ruby1.9.1-full libmysqlclient-dev libpq-dev libsqlite3-dev
    # gem1.9.1 install bundler

You'll have to make sure the Ruby gem path is in your terminal's `$PATH`.
For Debian, adding the following line to your `~/.bashrc` will do just
fine. Don't forget to restart your shell to enable this!

    PATH="/var/lib/gems/1.9.1/bin/:$PATH"

First, you'll need to download the source tree. Since this is a
development project, you'll have to use the latest and greatest release
(e.g. the Mercurial tip) for the time being.

    $ hg clone ssh://gescheurd.wasda.nl/~jorrizza/src/sinatra-mvc my_project
    $ cd my_project

Using bundler, we can install all of our gems without getting in the way
of your host Ruby installation. The following command will install the
gems in the `vendor/` directory and add the gem's applications in `bin/`.

    $ bundle install --path vendor --binstubs

To test your local bunch of gems, let's generate an HTML file out of this
documentation.

    $ bin/maruku README.md

This'll generate a nice HTML file for you.

Joris will update Sinatra MVC every once in a while. To get the latest
updates from his repository, just pull (and merge if needed).

    $ hg pull
    $ hg merge

Views
-----

Models
------

Controllers
-----------