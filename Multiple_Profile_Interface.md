## Configuration ##

  1. It is the responsibility of application to create, delete Kopal profiles and also match incoming requests to a Kopal profile.

To use multiple user interface, add following to `environment.rb`
```
  Kopal.multiple_user_interface!
```

In multiple user interface, if no _profile identifier_ can be supplied from `ApplicationController#kopal_determine_profile_identifier`, Kopal can redirect to another controller. However this is available only for the `root_url` of a Kopal profile.

```
  #Available only in @kopal_route.root_url in multiple profile interfaces.
  Kopal.redirect_for_home :controller => 'www', :action => 'index'
```



## Profile identifier ##

In multiple profile interface, each Kopal profile has a unique _profile identifier_ supplied from application, which can be used by the application to identify and access the same profile.

## Creating a user ##

To create a user, call the method `Kopal::KopalAccount.create_account()` with a unique identifier (called _profile identifier_).

Example -
```
  Kopal::KopalAccount.create_account('user_1');
```

## Routing ##

Whenever a request comes for Kopal, it needs to know which profile to choose to show. And so, it calles a method `kopal_determine_profile_identifier` which should be defined in application's `ApplicationController` and should return an `Array` with first value being the _profile identifier_ and second being the Kopal Identity associated with that _profile identifier_. This _profile identifier_ is same as the one provided while [creating the user's account](#Creating_a_user.md).

##  ##



