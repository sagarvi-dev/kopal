**This is a DRAFT, [comments are welcome](http://groups.google.com/group/kopal).**

**Draft status warning** - _This protocol is in concept stage and highly evolving. It may change radically without any backward compatibility. Here, be dragons._

# Contents #



# Abstract #

Kopal Feed is a publishing protocol. It's main purpose is to organise and publish a person's social information (profile) using XML markup language and let others understand, use, connect, search and share the social information with each other. It is a microformat.

Kopal Feed is an open standard and patent-free, available freely to use.

# Conventions and Definitions #

  1. The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](http://www.ietf.org/rfc/rfc2119.txt).

## Encoding and Representation ##

Kopal Feed uses XML for information representation encoded in UTF-8.

Official filename extension for Kopal Feed is _.kp.xml_.

# Kopal Feed #

**NOTE** - Only **Homepage** and **RealName** are required, rest every element is optional.

  1. **KopalFeed** The root element.
    1. (attribute) **revision** _(required)_ Implemented Kopal Feed revision.
    1. (attribute) **platform** _(optional)_ URI of the software publishing Kopal Feed.
    1. **Identity** - Represents user's profile.
      1. **Homepage** - Homepage of the user.
      1. **KopalIdentity** - Kopal Identity if user has one.
      1. **RealName** - Real name of the user.
      1. **Aliases** - Can have multiple **Alias** children, containing user's aliases. Only one of them can have attribute `preferred_calling_name` with value `true`. If one of them has attribute `preferred_calling_name`, this name should be used to name the user. If none of them has attribute `preferred_calling_name`, `RealName` should be used instead. It is an error for more that `Alias` to have the `preferred_calling_name` attribute.
      1. **Description** A _about me_ description of the user.
      1. **Image** - Image can be a URI or an embedded binary content determined by the value of `type` attribute. At present binary is not supported.
        1. (attribute) **type** _(required)_ Determines the type of Image. Can have value _uri_ or _binary_. If _uri_, Value of **Image** is an _absolute_ uri pointing to an image. If _binary_, Image contains the image encoded in Base64.
      1. **Gender** - Gender of the user, if present, MUST be `Male` or `Female` case sensitive.
      1. **Email** - Email of the user. (don't use it if your are paranoid, or see [#Extensions\_for\_Kopal\_Feed](#Extensions_for_Kopal_Feed.md)).
      1. **BirthTime** - Time of birth of user. (Please see [#BirthTime\_Date\_Format](#BirthTime_Date_Format.md) for formatting date).
      1. **Address**
        1. **Country** - Physical postal address for the **living** country.
          1. **Living** - Capitalised `ISO 3166-1 alpha-2 code` of country user is living it.
          1. **Citizenships** - Capitalised `ISO 3166-1 alpha-2 codes` of countires separated by comma "," (U+002C) (without spaces) of whose citizenhip user has acquired. If this element is not present AND `Country/Living` is  present, value of `Country/Living` is assumed as the value of `Country/Citizenships`.
        1. **Timezone** - User's preferred Timezone represented as offset from UTC in exact format of `±HH:MM` (WITH leading/trailing zeros if necessary). If this element is NOT present, AND `Country/Living` is present AND living country has only one Timezone, value of that Timezone is taken. For all other cases, UTC (+00:00) is considered.
          1. (TODO: Support for DST).
          1. (DRAFT: If Timezone is not present, should time-zone directly be considered to be UTC? Determining correct time-zone should be responsibility of generating software and not of parsing one).
        1. **City** City code of the city if city has a code in supported standards. Otherwise name of the city itself.
          1. (attribute) **standard** - Name of the standard form which city code has been chosen. At present only `un/locode` is supported. Don't use this attribute if using the name of the city itself.
        1. **StreetAddress** - Street address of the user.
        1. **PostalCode** - Postal code of street address.
        1. **Telephones** - Telephone numbers separated by a comma "," (U+002C) (without spaces). All telephone numbers MUST start with ISD (IDD) code, containing only digits from 0-9, except the first character which MUST be a plus sign "+" (U+002B) to signify that number starts with a ISD code.
        1. **GeographicCoordinate** - Geographic co-ordinate as per the standard.
          1. (attribute) **standard** _(required)_ - Standard used to represent the geographic co-ordinates. At present only `ISO 6709` (written as `iso6709`) is supported.
    1. **Friends** - List of friend's Kopal Feed in children elements **Friend**.


## BirthTime Date Format ##

`BirthTime` element of Kopal Feed displays the Time of birth of the user. Syntax of representation is derived from ISO 8601 / RFC 3339 with the addition of some of its own syntax. Since Kopal Feed allows `BirthTime` to have only day and month without year of year and month without a day. BirthTime allows time precision up to the extent identified by ISO 8601.

(For any ambiguity please refer [RFC 3339](http://www.ietf.org/rfc/rfc3339.txt)).

**Note** - If time is present, it MUST only be represented in UTC and only in 24-hour format.

At present moment, `BithTime` supports four formats for representation of Time of birth.

  * `YYYY`
  * `YYYY-MM`
  * `YYYY-MM-DD`
  * `YYYY-MM-DDTHH:MM:SS.FFZ`

**Note** - `MM-DD` is possible by setting `YYYY` to be `0000` in `YYYY-MM-DD`. (Example usage: Hide age while showing date of birth).

Where,

  1. `YYYY` is number of year in four digits.
  1. `MM` is number of month in two digits. January is `01`.
  1. `DD` is the number of day in two digits. First day is `01`.
  1. `HH` is the number of hour in two digits, 00-23 inclusive.
  1. `MM` is the number of minute in two digits, 00-59 inclusive.
  1. `SS` is the number of second in two digits, 00-59 inclusive.
  1. `FF` is fraction of second with variable length of digits (minimum two).
  1. `T` realises the presence of time, written as it is.
  1. `Z` realises that time is a UTC time, written as it is. (Z must be present if time is present, since no other time-zone is allowed).

### Example ###

#### Good Examples ####

  * 1988
  * 1988-06
  * 0000-06-22
  * 1988-06-22
  * 1988-06-22T15:40:00.00Z

#### Bad Examples ####

(Please note that they are valid in ISO 8601/ RFC 3339)-

  * 06-04 (Year missing.)
  * 1988-06-22T15:40 (Seconds missing.)
  * 1988-06-22T15:40:00 (fraction part of second is missing.)
  * 1988-06-22T15:40:00.00 (Local time is not allowed, `Z` must be present.)

# Kopal Feed Example #

## Example of Kopal Feed with Minimum Elements ##

```
<?xml version="1.0" encoding="UTF-8" ?>
<KopalFeed revision="0.1.draft">
 <Identity>
  <Homepage>http://example.net/</Homepage>
  <RealName>Example</RealName>
 </Identity>
</KopalFeed>
```

## Generic Example ##

```
<?xml version="1.0" encoding="UTF-8" ?>
<KopalFeed revision="0.1.draft" platform="kopal.googlecode.com">
  <Identity>
    <Homepage>http://vikrant.co.in/</Homapage>
    <KopalIdentity>http://its.raining.in/</KopalIdentity>
    <RealName>Vishwa Pratap Singh</RealName>
    <Aliases>
      <Alias>Vikrant</Alias>
      <Alias preferred_calling_name="true">Vikrant Chaudhary</Alias>
    <Aliases>
    <Description>
      Vikrant Chaudhary (Vishwa Pratap Singh, in papers) is a Computer Programmer from India. He is the lead developer of Kopal.
    </Description>
    <Image type="uri">http://its.raining.in/home/profile_image/vikrant_chaudhary.jpeg</Image>
    <Gender>Male</Gender>
    <Email>nasa42+hi@googlemail.com</Email>
    <BirthTime>1988-06-22</BirthTime>
    <Address>
      <Country>
        <Living>IN</Living>
        <Citizenships>IN</Citizenships>
      </Country>
      <Timezone>+05:30</Timezone>
      <City standard="un/locode">IN LKO</City>
      <StreetAddress>(Don't panic! This is optional of course).</StreetAddress>
      <Postalcode>1234567890</Postalcode>
      <Telephones>+910123456789;+919876543210</Telephones>
      <GeographicCoordinate standard="iso6709">+26.860556+80.915833/</GeographicCoordinate>
    </Address>
  </Identity>
  
  <Friends>
    <Friend>http://example.org/feed.kp.xml</Friend>
    <Friend>http://example.net/feed.kp.xml</Friend>
  </Friend>
</KopalFeed>
```

# Extensions for Kopal Feed #

This section documents usage of Kopal Feed along with Kopal Connect. This is not a required part of the Kopal Feed standard as it depends on Kopal Connect, and one of primary goals of Kopal Feed is to be independent of any other standard for a full implementation.

Using Kopal Connect, user may display different Kopal Feed for different person. For example he may choose to display `Email` only to his friends and not to public. (TODO: Write me).

# See Also #

  1. [Kopal Connect](Kopal_Connect.md)
  1. [Kopal for Developers](Developer.md)