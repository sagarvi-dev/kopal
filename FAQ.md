

## Installation ##

#### ERROR - A copy of ApplicationController has been removed from the module tree but is still active! ####

<a href='Hidden comment: Update with new Rails release, if gets fixed.'></a>

If after installing Kopal, you are getting error like `A copy of ApplicationController has been removed from the module tree but is still active!`, try writing this in your _config/environments/development.rb_ file.

```
  ActiveSupport::Dependencies.explicitly_unloadable_constants << 'Kopal'
```

Also, if you are writing some Kopal specific configurations in _config/environment.rb_, you'll have to rewrite them in `ApplicationController#before_filter`, since now Kopal module will be reloaded on every request while _config/environment.rb_ gets loaded only once, so your configurations will be valid only for first request.