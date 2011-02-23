Sinatra MVC
===========

Sinatra MVC is a simple attempt to get some kind of MVC structure on top
of Sinatra, without losing much of the original Sinatra _"feeling"_. It
uses Datamapper for it's model layer and custom software for the other
two.

It's recommended to read the [Sinatra README][6] first before continuing
with this document.

A rule of thumb: In command line examples, a `$` prefix means your own
user and a `#` prefix is a root terminal.

A big fat warning: Sinatra MVC < 0.1.0 is not fit for production. The API
_will_ change with almost _every_ release during sub-0.1.0 development.
Feel free to play around with it, though.

System Dependencies
-------------------

Your system needs to have a working Ruby 1.9.2 installation (or later,
but I haven't tested that). You'll also need some kind of database. The
currently supported databases are all of the database backends
[supported][10] by DataMapper.

Sinatra MVC also has the possibility to use Memcache as a session storage
system. This is the default. It's recommended as well.

The framework has been developed on a Debian Sid platform, and as such
Debian is the preferred platform of choice. If you encounter problems
caused by Debian-specific hacks, please let me know. The interpreter
string has been set to `ruby1.9.1`, but you can easily change that in
the `bin` directory  if you wish. Don't worry, that's the only place the 
"weird" interpreter string is used.

Throughout the documentation Debian-specific help will be provided. Other
operating systems might be added later.

Installing
----------

Installing Sinatra MVC is reasonably simple. All you need is Ruby Gems,
some development headers (distributed by your operating system) and
a terminal.

For Debian users, the following command will suffice (or ask your system
administrator to install the packages for you):

    # apt-get install ruby1.9.1-full libmysqlclient-dev libpq-dev libsqlite3-dev build-essential

You'll have to make sure the Ruby gem path is in your terminal's `$PATH`.
For Debian, adding the following line to your `~/.bashrc` will do just
fine. Don't forget to restart your shell to enable this!

    PATH="/var/lib/gems/1.9.1/bin/:$PATH"

The simplest method is using Rubygems. For Debian, use `gem1.9.1` instead
of `gem`.

    # gem install sinatra-mvc

Or for the latest and greatest, you can need to download the source tree.
It's available on both [Github][8] and [Bitbucket][9], but both are only
mirrors of the development tree at wasda.nl.

    $ cd $HOME/src
    $ hg clone https://bitbucket.org/jorrizza/sinatra-mvc
    - or if you prefer github -
    $ git clone git://github.com/jorrizza/sinatra-mvc.git
    $ cd sinatra-mvc
    $ gem build sinatra-mvc.gemspec
    # gem install sinatra-mvc-*.gem

Now we've got sinatra-mvc installed, let's start our own project.

    $ cd $HOME/src
    $ sinatra-mvc-project my_project
    $ cd my_project

Yay! A project!

Using bundler, we can install all of our gems without getting in the way of
your host Ruby installation. The `sinatra-mvc-project` utility has already
installed the bundler files in your project with the default set of gems.

Updating gems is pretty easily done. Now you've got your bundle complete,
you'll just have to run:

    $ bundle update

When you need more gems to be added to your project, simply edit the
`Gemfile` and run

    $ bundle update

again. This will make sure the dependencies of your application, as supplied
in the `Gemfile`, will be available to your project. For further
documentation about the `Gemfile`, read the [Bundler documentation about
the `Gemfile`][17]

Sharing your project with others
--------------------------------

The project is prepared for use in Git and Mercurial. It's recommended to
make a repository of your project directory right from the get-go.

For example, when using Mercurial:

    $ cd $HOME/src/my_project
    $ hg init
    $ hg add * .gitignore .hgignore
    $ hg commit -m "First commit."

When your friend clones your repository, the Bundler cache is not included.
The Bundler installer has to be re-run for a clone of your project.

Again, an example using Mercurial:

    $ hg clone ~jameshacker/src/my_project $HOME/src/my_project
    $ cd $HOME/src/my_project
    $ bundle install --path vendor --binstubs

Updating
--------

For a Rubygems installation simply run:

    # gem update

To get the latest updates from the repository, just pull (and merge if
needed).

    $ cd $HOME/src/sinatra-mvc
    $ hg pull
    $ hg update
    - or when using github -
    $ git pull
    $ rm sinatra-mvc-*.gem
    $ gem build sinatra-mvc.gemspec
    # gem install sinatra-mvc-*.gem

Configuration
-------------

The main configuration is defined in `conf/settings.yml`. It's the place
where you can use the Sinatra `set` method to change Sinatra's behaviour.
Nothing keeps you from setting configuration parameters in controllers,
but please keep things nicely tucked away in this file. Every field will
be translated to a `set :field, value` call.

For sessions there are three configuration parameters you can set. The
`session_max_age` determines the age of the session cookie in seconds.
After this amount of time, the cookie is denied and browsers should
automatically discard it. There are two session backends you can choose
from. If you set `session_backend` to `:cookie`, all the session values
will be stored in the cookie itself. Even though it will be encrypted,
this is not a very safe thing to do. It also limits your storage to the
maximum allowed cookie size, which varies from browser to browser. The
preferred setting is `:memcache`, which will use memcache as a session
backend. It doesn't limit your session size that much, and can scale
pretty well. Set the `session_store` to either a string or an array of
strings for a single server or a memcached cluster. The format is
`hostname:port`. This value will be ignored for the `:cookie`
`session_backend` setting. So for a single memcache server you define:

    session_store: hostname:11211

And for a memcache cluster:

    session_store:
      - hostname1:11211
      - hostname2:11211
      - hostname3:11211

If you want to change the path to the views root directory, you can change
the `views_root` setting. It's `views` by default. This is interpreted as
a subdirectory of your project.

The same applies to the `public` setting, which should point to the
directory within your project from which static content is being served.

For i18n you can set the default locale using `default_locale`. This is
the name of the file in the `translations` directory, without the `.yml`
file extension. Just like `views_root`, `translations` is a subdirectory
of your project.

The development server socket can be configured using the `port` and `bind`
options. These determine the TCP port and the listen address of the
development server. These will be ignored when you're using the rackup file
to run your server (i.e. any other method than running `sinatra-mvc`).

The database connection is defined by `database_connection`.  The value is
a string, following the syntax:

* `sqlite::memory:` for in-memory Sqlite3 storage
* `sqlite:///path/to/file.db` for file-based Sqlite3
* `mysql://user:pass@server/database` for the MySQL RDBMS
* `postgres://user:pass@server/database` for the PostgreSQL RDBMS

You can read the settings file using the `Settings.settings` call, which
will return a Hash of your settings. Alternatively you can read the
configuration Sinatra received by using the `settings` object like explained
in the [Sinatra settings documentation][15]. These two differ slightly,
mainly in the fact that Sinatra isn't aware of the project directory.

Running your Application
------------------------

Sinatra is built on top of Rack, so every method that can run Rack will
be able to run your Sinatra MVC application. That even includes things
like [Shotgun][2], [Phusion Passenger][3] and [Heroku][4].

There are basically two ways to run your application. During development,
it's okay to run your application using the built-in thin server. This
will serve all the static files and handle the application calls at the
same time. Just simply run:

    $ cd my_project
    $ sinatra-mvc

This will run your application in development mode, allowing you to see
the access log in the terminal and tracebacks when you've made an _oops_.
It also enables nicely formatted error pages, generated by Sinatra.

Another method is using the `PROJECT` environment variable.

    $ PROJECT=~/src/my_project sinatra-mvc

In production, there are several ways you can use Rack to serve your app.
I suggest using thin, proxied by Nginx for the static files. The
supplied `config.ru` Rackup file will handle things for you. Be sure to
configure your server to run in production mode. This will disable the
helpful error messages and other development coolness.

An example using Shotgun:

    # gem1.9.1 install shotgun
    $ shotgun ~/src/my_project/config.ru

Or:

    $ cd ~/src/my_project
    $ shotgun

Static Files
------------

By default, static files are served from the `public/` directory. If you
create a file at `public/css/site/main.css`, the HTTP request to 
`/public/css/site/main.css` will serve that file. You're completely free
to specify your own directory structure.

Controllers
-----------

Controllers are vastly simplified and are not at all linked to models.
If you want to make it so, you're free to do so. The controller files
reside under `app/`. All of the files are read recursively in order during
application startup. This means you can apply a sane directory structure
to the app directory to make your controllers easier to understand. Since
only the application's startup time is slightly influenced by the
complexity of the directory structure and the amount of files in them,
you're encouraged to split up your controllers as much as needed.

The code that goes into these files ends up in Sinatra's [application
scope][5]. You can fully use Sinatra's DSL to get things done. To keep
the original Sinatra _vibe_ alive, there's no central routing method.
Instead, you're required to use Sinatra's DSL to specify what happens
after what request.

Let's assume you've got a blog with posts, and you want to edit a certain
post. In this case, you might choose for the following file:
`app/post/modify.rb`.

    get '/post/modify/:id'
      @post = Post.get id
      halt 404 unless @post

      erubis :post_modify
    end

    post '/post/modify/:id'
      @post = Post.get id
      halt 404 unless @post

      fetch 1, @post, '/post/read/' + id, nil

      erubis :post_modify
    end

As you can see, not much has been changed from the original concept.
The post itself is a Datamapper model, and is used a such.

In the post bit of the controller there's an awesome little function call,
allowing you to populate your model with incoming POST data. The `fetch`
function is designed to tackle most, but not all, handling of incoming
request data. It's built on top op Datamapper and expects either an object
or a class of a Datamapper model as it's second parameter. The spec:

    fetch [1|n], [object|class], url_on_success = referer, url_on_failure = referer

The first parameter (`1` or `n`) switches functionality between fetching
a single object, or multiple objects of the same type. _Only single
object fetching is supported for now_. The second argument accepts both
classes and objects of Datamapper models. If it's a class, it will create
a new object using the received values and saves it to the database. If it's
an existing object, it will modify the object using the received fields.
Be sure to have your form field name attributes match the Datamapper field
names. If you have any other fields that end up in the `params` hash, make
sure the fields do not overlap. Both URL filters (like `get '/my/:id' do
... end`) and normal HTTP GET parameters (like `/my/?id=1`) interfere with
the `params` variable `fetch` uses. Internally the function will handle
Datamapper validation and will only write to the database when everything
checks out. The errors will be displayed using flash messages after a 
redirect. That's what the last two parameters are for. Both are optional.
When excluded, they'll have the value of the current referer. The first
is the redirect on success URL. This will keep the back button from
resending the POST data. The second one is the redirect on failure URL.
When nil is given, no redirection will take place and control will be given
back to the controller, allowing you to have the conditional form fields
(`c` function) in your view display the sent data.

The flash messages aren't only available to the `fetch` function, but
you're allowed to set them yourself as well. There are two methods of using
the flash messages. You can alter the `flash` variable itself. The variable
is a hash with two possible fields. `:info` contains information, in either
and array or a string. `:error` contains the same, but for errors. If you
set the flash message, the first view that is rendered will display the
values. Take a look at `views/flash_message.erubis` for the markup. The
second method uses an extention to the `redirect` function, allowing you
to supply a message to be displayed after a redirect. Example:

    redirect '/naked/horses', :info => 'Stand the f*ck back!'

Or more messages:

    redirect '/naked/penguins', :info => ['This is unfunny', 'This kind of turns me on']

Or several types:

    redirect '/naked/cows', :flash => {:info => 'Horny, get it?', :error => 'Not funny!'}

Views
-----

Sinatra MVC has all the [view options][1] Sinatra has. Some things differ
though, since this framework supports an URL-directory mapping for views.

Using _erubis_ is recommended, but you might as well use other templating
methods. Any template method supported by the tilt library, included by
Sinatra, can be used. Just make sure you've added the library to the
`Gemfile` and included it in the `conf/environment.rb`.

Some sidemarks with this selection of templating solutions:

* You can use less. Sinatra MVC wants to keep things speedy, so please use
  `bin/lessc` to compile your less templates. Unless you've got a proper
  cache of course.
* Markdown support in R18n is done using Maruku, but Sinatra (tilt) prefers
  rdiscount. Both are included in the default `Gemfile`. One of the future
  things that will be done is removing one of the two. This will have to do
  for now.

Normally, you have to do weird stuff in Sinatra like using
`:'directory/my_view.erubis'` for rendering views in sub directories.
Sinatra MVC has added automatic view prefixes. The former method of using
hardcoded prefixes still works, but now there's URI-based mapping as well.
In short, it uses the views from the directory path in the view directory
if that path matches the URI prefix. For example, if you have a controller
like this:

    get '/my/little/pony/pink'
      erubis :pink
    end

It will render a page using `views/my/little/pony/pink.erubis`, but only
if that directory exists. This directory will be used as the new view
prefix, so make sure every directory has at least the following files:

* `layout.erubis`
* `not_found.erubis`
* `flash_message.erubis` (only if layout requires it)

This construction allows you to create prefix-based sub sites, each with
it's own look and feel. Originally this has been created to allow for
admin areas and the like.

Views have a neat little function for displaying form values. It's called
conditional form field (`c` for short). The `c` function will take two
parameters, here's the spec:

    c field, object = nil

The field is a symbol of the field from your Datamapper model. This
function will check if your field is found in POST data, and will display
that value. If it's not, it will return an empty string. Unless you've
supplied the second parameter, which is a Datamapper object. If the
object contains a value for that field, that will be displayed in stead
of an empty string. Here's a practical example for the `c` function for
handling a post's content.

    <td><textarea name="content"><%=c :content, @post %></textarea></td>

The `c` function will automatically call `h` when creating output. The
`h` function escapes HTML, just like in Rails.

Models
------

Sinatra MVC uses Datamapper for it's models. Just like the controllers, 
the models are included recursively so you are allowed to create your own
structure in the `models` directory.

For documentation regarding Datamapper, please visit de [Datamapper
documentation][7]. Some popular plugins are provided:

* [dm-migrations][12]: Adds migration support. Used by provided utils.
* [dm-aggregates][13]: Adds aggregation support (COUNT() and the like).
* [dm-validations][14]: Adds validation. Used extensively.

If you want to add more `dm-*` modules, just add them to your `Gemfile`
and include them in the `conf/environment.rb` file.

The classed defined in the models are automatically available in the
controllers.

When you've created your models, you can check and initialize them by
running:

    $ cd my_project
    $ sinatra-mvc initdb

This will initialize your database, but beware, it'll purge every model
defined in your `models` directory. If you just want to migrate your models
(e.g. update the database to reflect your models), just run:

    $ cd my_project
    $ sinatra-mvc upgradedb

This will only update the tables in such a way it can't modify any of the
data already present. To do that, you'll have to write migrations. This
functionality is lacking at the moment. Datamapper is able to run
migrations, but nobody bothered documenting how they work.

Internationalisation
--------------------

Internationalisation is done using R18n. This method allows for neat
integration into Sinatra. The documentation is complete and available on
[their site][16].

Utilities
---------

Utilities are scripts you can run within the Sinatra MVC environment. It's
pretty much what Rails does using `rake`, but without the complexity. Just
add a file in the `utils` directory and do whatever you want to do.
You can use the database like you're used to. The utils are meant to
function as cron jobs or management processes. As you can see, the database
scripts are already provided.

To run a script, simply call:

    $ cd my_project
    $ sinatra-mvc <scriptname without .rb>

Tests
-----

Since version 0.0.4 tests are intergrated into Sinatra MVC. If you
value stability in an application, tests are an awesome way to meet that
goal. [`Rack::Test`][18] is used to define and run tests on your
application.

The Sinatra DSL is augmented by a test function. This fuction works as a
skeleton to house your tests. This function also tracks your test coverage.
When testing, the output will tell you if you've covered all your code
with tests. The method it uses is reading the defined controller paths, and
matching that with the defined tests. It's recommended to define the tests
in the same file as the actual code. If you don't like this approach for
what ever reason, a separate `app/tests` directory will do as well.

Here's an example:

  get '/horse/:name' do |name|
    "Hello horsey! Hello #{h name}!"
  end

  test '/horse/:name' do
    def test_horse_name
      get '/horse/pwny'
      assert last_response.body == 'Hello horsey! Hello pwny!'
    end
  end

Within the `test '/path' do ... end` body you can use all of the Rack::Test
functionality you normally use in standard tests. The same gotchas apply
here. All of the test functions have to have the `test_` prefix. Test
functions should be unique. All of the Sinatra MVC test function bodies
share a single scope.

At the moment automatic test coverage reporting does not understand the
difference between HTTP methods. You'll have to make sure to test all of
the methods that use the same path yourself. In the future Sinatra MVC
will track your `Rack::Test` usage as well, to provide a complete test
coverage report.

Running the tests is easy. Just run:

  $ cd ~/src/my_project
  $ sinatra-mvc test

The `--verbose` flag shows more information about the running tests. All
the `Rack::Test` command line flags are also supported and used.

Single Character Reserved Variables
-----------------------------------

Just don't use these as variables within controllers and views, mkay?

* `h - ` HTML escaping function.
* `t - ` Translation function (R18n).
* `c - ` Conditional form field.
* `n - ` Just meaning "n" of something.

[1]: http://www.sinatrarb.com/intro#Views%20/%20Templates
[2]: http://rtomayko.github.com/shotgun/
[3]: http://www.modrails.com/
[4]: http://heroku.com/
[5]: http://www.sinatrarb.com/intro#Application/Class%20Scope
[6]: http://www.sinatrarb.com/intro
[7]: http://rubydoc.info/gems/dm-core/1.0.2/frames
[8]: https://github.com/jorrizza/sinatra-mvc
[9]: https://bitbucket.org/jorrizza/sinatra-mvc
[10]: https://github.com/search?langOverride=&q=dm+adapter&repo=&start_value=1&type=Repositories
[12]: http://www.rubydoc.info/gems/dm-migrations/1.0.2/frames
[13]: http://www.rubydoc.info/gems/dm-aggregates/1.0.2/frames
[14]: http://www.rubydoc.info/gems/dm-validations/1.0.2/frames
[15]: http://www.sinatrarb.com/configuration.html
[16]: http://r18n.rubyforge.org/sinatra.html
[17]: http://gembundler.com/man/gemfile.5.html
[18]: https://github.com/brynary/rack-test