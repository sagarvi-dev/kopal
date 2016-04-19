### Getting Kopal ###

Getting a development copy of Kopal requires that you have [Mercurial](http://www.selenic.com/mercurial/) installed. See http://hgbook.red-bean.com/read/a-tour-of-mercurial-the-basics.html for more informaion on how to install Mercurial.
After installing Mercurial run following commands to get your development copy of Kopal.

  * In your Rails application directory and type the following in a terminal.

```
hg clone http://kopal.googlecode.com/hg/ vendor/plugins/kopal
rake kopal:first_time
```

  * Open _config/routes.rb_ of your application and type following. It doesn't matter where you type it, in the block of `ActionController::Routing::Routes.draw` or before it.

```
Kopal.draw_routes
```

You should now have a working Kopal development copy.

### Updating local repository ###
Just run following command in `vendor/plugins/kopal` directory, whenever you want to update your local repository of Kopal.

```
hg pull && hg update
```

# Workflow #

_PLANNIG: Kopal should be a rolling release rather than versioned one with major revisions tagged as `rYYYY_MM_DD`. Should have two branches "default" for stable and "lab" for working. Since http://kopal.googlecode.com/hg/ can not be browsed branch wise, we can have a text file checked in root which always contains the revision number of head of default branch, so that `kopal:update` can update to latest release._

_PLANNING 2: Since help page for `hg branch` states that `default` branch should be used for primary development. Will close `lab` and create `release` branch._

Kopal uses _Mercurial_ for revision control. Kopal recommends using `hg clone` over `hg branch`.
Named branches should be created only if they are of high importance in history, for example release branches.

## Directory Structure ##
Kopal recommends following directory structure (`bzr` like) for Kopal's development.
```
  kopal/default #Default branch
  kopal/branch2 #Use cloning rather than branching
  kopal/r2010.0 #Real branches are also represented using subdirectories.
  kopal/kopal-app #The sample application (if any) goes here. kopal/kopal-app/vendor/plugins/kopal should be a symlink to ../../../default
```