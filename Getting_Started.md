

# Installation #

**Meeting the requirements**

Kopal's first (and at present, only) implementation is written in [Ruby programming language](http://en.wikipedia.org/wiki/Ruby_(programming_language)) using [Ruby on Rails](http://www.rubyonrails.org/) framework and [MongoDB](http://www.mongodb.org/) as database backend.

  1. Install and create a Rails 3 application - http://rubyonrails.org/download
  1. Install MongoDB - http://www.mongodb.org/downloads#packages

**Including Kopal gems**

In your Rails 3 application, add following lines in `Gemfile` -

```
 git "git://gitorious.org/kopal/kopal-ro.git" do
   gem "kopal"
   gem "kopal-rails"
 end
```

**Initialisation and setup**

Run following rake task

```
  rake kopal:first_time
```

All done! Fire up the server and your Kopal profile should be available at http://localhost:3000/profile/

# Upgrading #

Whenever you update   -

```
  rake kopal:upgrade
```

# Using Google Analytics #

_Google Analytics_ (or any other code) can be included by using _theme filters_.
To create a filter, create a file at following path
which contains the code of Google Analytics.
```
  RAILS_ROOT/app/views/_kopal_filter/_before_body_close.html.erb
```

For more information about filters, see - http://www.avik.in/kopal/api/Kopal/Theme/Filter.html


# See Also #

  * [FAQ](FAQ.md)