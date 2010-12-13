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

Updating gems is pretty easily done. Now you've got your bundle complete,
you'll just have to run:

    $ bundle update

Joris will update Sinatra MVC every once in a while. To get the latest
updates from his repository, just pull (and merge if needed).

    $ hg pull
    $ hg merge

Configuration
-------------

The main configuration is defined in `conf/settings.yml`. It's the place
where you can use the Sinatra `set` method to change Sinatra's behaviour.
Nothing keeps you from setting configuration parameters in controllers,
but please keep things nicely tucked away in this file. Every field will
be translated to a `set :fied, value` call.

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

For i18n you can set the default locale using `default_locale`. This is
the name of the file in the `translations` directory, without the `.yml`
file extension. Just like `views_root`, `translations` is a subdirectory
of your project.

The database connection is defined by `database_connection`.  The value is
a string, following the syntax:

* `'sqlite::memory:'` for in-memory Sqlite3 storage
* `'sqlite:///path/to/file.db'` for file-based Sqlite3
* `'mysql://user:pass@server/database'` for the MySQL RDBMS
* `'postgres://user:pass@server/database'` for the PostgreSQL RDBMS

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

    $ ./sinatra-mvc.rb

This will run your application in development mode, allowing you to see
the access log in the terminal and tracebacks when you've made an _oops_.
It also enables nicely formatted error pages, generated by Sinatra.

In production, there are several ways you can use Rack to serve your app.
I suggest using thin, proxied by Nginx for the static files. The
supplied `config.ru` Rackup file will handle things for you. Be sure to
configure your server to run in production mode. This will disable the
helpful error messages and other development coolness.

Static Files
------------

Static files are served from the `public/` directory. If you create a file
at `public/css/site/main.css`, the HTTP request to 
`/public/css/site/main.css` will serve that file. You're completely free
to specify your own directory structure.

Controllers
-----------

Controllers are vastly simplified and are not at all linked to models.
If you want to make it so, you're free to do so. The controller files
reside under `app/`. All of the files are read recursively during
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
methods. At the moment the following things are supported (notice the lack
of the nasties _builder_, _haml_ and _sass_):

* erubis
* markdown
* textile
* liquid
* less

Some sidemarks with this selection of templating solutions:

* You can use less, but not as a template call. Sinatra MVC wants to keep
  things speedy, so please use `bin/lessc` to compile your less templates.
* Markdown support in R18n is done using Maruku, but Sinatra (tilt) prefers
  rdiscount. Both are included. One of the future things that will be done
  is removing one of the two. This will have to do for now.

Normally, you have to do weird stuff in Sinatra like using `:'directory/
my_view.erubis'` for rendering views in sub directories. Sinatra MVC has
added automatic view prefixes. The former method of using hardcoded
prefixes still works, but now there's URI-based mapping as well. In short,
it uses the views from the directory path in the view directory if that
path matches the URI prefix. For example, if you have a controller like
this:

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

* [dm-timestamps][8]: Add created/modified timestamps.
* [dm-tags][9]: Add tags to any model.
* [dm-is-tree][10]: Create a tree out of a model.
* [dm-is-list][11]: Create a list of models.
* [dm-types][12]: Allows the use of more field types.
* [dm-aggregates][13]: Adds aggregation support (COUNT() and the like).
* [dm-validations][14]: Adds validation. Used extensively.

The classed defined in the models are automatically available in the
controllers.

When you've created your models, you can check and initialize them by
running:

    $ ./sinatra-mvc.rb initdb

This will initialize your database, but beware, it'll purge every model
defined in your `models` directory. If you just want to migrate your models
(e.g. update the database to reflect your models), just run:

    $ ./sinatra-mvc.rb upgradedb

This will only update the tables in such a way it can't modify any of the
data already present. To do that, you'll have to write migrations. This
functionality is lacking at the moment. Datamapper is able to run migrations,
but nobody bothered documenting how they work.

Internationalisation
--------------------

TODO

Utilities
---------

TODO

Single Character Reserved Variables
-----------------------------------

Just don't use these as variables within controllers and views, mkay?

* `h - ` HTML escaping function.
* `t - ` Translation function (R18n).
* `c - ` Conditional form field.
* `n - ` Just meaning "n" of something.

[1]: http://rubydoc.info/gems/sinatra/1.1.0/file/README.rdoc#Views___Templates
[2]: http://rtomayko.github.com/shotgun/
[3]: http://www.modrails.com/
[4]: http://heroku.com/
[5]: http://www.rubydoc.info/gems/sinatra/1.1.0/file/README.rdoc#Application_Class_Scope
[6]: http://www.rubydoc.info/gems/sinatra/1.1.0/file/README.rdoc
[7]: http://rubydoc.info/gems/dm-core/1.0.2/frames
[8]: http://www.rubydoc.info/gems/dm-timestamps/1.0.2/frames
[9]: http://www.rubydoc.info/gems/dm-tags/1.0.2/frames
[10]: http://www.rubydoc.info/gems/dm-is-tree/1.0.2/frames
[11]: http://www.rubydoc.info/gems/dm-is-list/1.0.2/frames
[12]: http://www.rubydoc.info/gems/dm-types/1.0.2/frames
[13]: http://www.rubydoc.info/gems/dm-aggregates/1.0.2/frames
[14]: http://www.rubydoc.info/gems/dm-validations/1.0.2/frames
[15]: http://www.sinatrarb.com/configuration.html