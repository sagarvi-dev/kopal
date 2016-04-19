

# Naming Conventions #

## URI Naming ##

  * Must always be in singular form, i.e., _/home/friend/_ and **not** _/home/friends/_
  * Should have a folder like feeling and not file like, i.e., URLs should end with a trailing slash.

## Release Naming ##

### Kopal Connect / Kopal Feed Naming ###

Release of Kopal Connect and Kopal Feed are called "revision". And it has a syntax of `major.minor.draft`, Where `major` and `minor` are the major and minor relase numbers respectevly. `draft` word postfixed to release which are newly revised, haven't been tested enough and are likely to change.

Example -

  * 0.1.draft
  * 1.0

### Kopal Software Naming ###

A Kopal Rails implementation (Kopal Software from now on) release is called "version". And it has a syntax of `year.major.status.minor`. Where `year` is the year of release (for unstable versions, it is the expected year of stable version release.). `status` can be one of `a`/`alpha`, `b`/`beta`, `c`/`rc` or `g`/`gamma`. `status` is optional with default value of `gamma`. (Short form of `rc` is not `r` but `c`, so that stablility order matches alphabetical order. `a` → `b` → `c` → `g`).
For each year `major` starts from 0. For `a`, `b`, `c`, minor version should start with 1, while for `g` it should start with 0.

Example -

  * 2010.0.alpha.1
  * 2010.0.a.2
  * 2010.0.b.1
  * 2010.0.rc.1
  * 2010.0 (Equal to 2010.0.g.0)
  * 2010 (Equiv. to above).
  * 2010.0.g.1 (first minor update to first stable release).
  * 2010.1 (Second major release in year 2010).