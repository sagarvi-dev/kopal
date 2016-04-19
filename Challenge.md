

# Keeping User Signed-In Across Social Network #

Kopal is decentralised and doesn't depend on a central server to function, hence we can not use a centralised
server authentication or domain-dependent cookies to keep user signed-in while she visits Kopal profiles across the web.

In short, the purpose is to let user take her (authorised) identity while she surfs the Kopal web.

## Solution 1 ##

**Using OpenID**

Every time a user visits a Kopal profile, she is automatically authorised against her Kopal Identity (which also acts as OpenID).
For this purpose whenever a user leaves a Kopal profile for another, a GET parameter `kopal.visitor` is appended to the URL.

_A user's server may keep a list of all Kopal profiles which have requested a sign-in and ask them to sign-out the user when user wishes to._

Example -

  1. Alice's Kopal profile is http://alice-profile.example/
  1. She is viewing "friends" page of her profile at http://alice-profile.example/friend/
  1. Now to visit her friend Bob's profile, she clicks on Bob's Kopal profile link which is http://bob-profile.example/?kopal.visitor=http://alice-profile.example/
  1. Server at http://bob-profile.example/ now authenticates http://alice-profile.example/ using OpenID.
  1. Now if she clicks on http://eve-profile.example/ while visiting http://bob-profile.example/friend/, she'll be redirected to http://eve-profile.example/?kopal.visitor=http://alice-profile.example/ and the OpenID authentication repeats.

### Advantage ###

  1. Truly decentralised.

### Drawback ###

  1. For every new Kopal profile visit, an OpenID authentication shall have to take place.
  1. User can not be signed-in, if the address of Kopal Profile does not has a GET parameter of `kopal.visitor`. (Example: Entering profile address directly in address bar.)

## Solution 2 ##

**Using a browser plug-in**

A browser plug-in with which Kopal profiles can interact. When a user signs-in at a Kopal profile, the browser plug-in may detect it.
All visiting Kopal profile may detect the plug-in and interact with plug-in to identify the user.

  1. Alice signs-in to her Kopal profile at http://alice-profile.example/
  1. Alice's browser detects that a Kopal Profile sign-in has taken place and it records the signed Kopal Identity. _(Example: like Google Toolbar)._
  1. Alice now visits http://bob-profile.example/
  1. Alice's browser now informs http://bob-profile.example/ that Alice (http://alice-profile.example) is signed-in. _`FIXME: http://bob-profile.example/ may verify the information sent by browser. But then again it is solution#1. Or we may use some PKI for verification instead of long OpenID authentication.`_

### Advantage ###

  1. Fastest way of signing-in.

### Drawback ###

  1. Browser dependency.
  1. Requirement of a browser plug-in.
  1. Security attacks are possible. Browser may act representing someone it is not. (For friends, we may ask for _friendship key_.). _`(Name of this type of attack? imposing someone else?)`_

## Solution 3 ##

**Using a centralised ~~authentication~~ tracking server.**

When a user signs-in on her Kopal profile, Cookies are stored for a domain managed by Kopal team.

Example -

  1. Alice signs-in to her Kopal Profile at http://alice-profile.example/
  1. Some JavaScript code at http://alice-profile.example/ sends information to http://kopal-server/ informing that http://alice-profile.example/ has signed in.
  1. http://kopal-server/ verifies this and marks http://alice-profile.example/ as the signed-in profile for this session. (For example by storing cookies).
  1. Alice now visits http://bob-profile.example/
  1. Some JavaScript code at http://bob-profile.example/ may now ask http://kopal-server/ about the signed-in Kopal Identity.

### Advantage ###

  1. Simple to implement, on both sides. _`(At server side, just two page simple _PHP_ scripts (one for authentication and one for identification) and a single database table. No backup needed.)`_

### Drawback ###

  1. Against _distributed and decentralised social network_ philosophy.
  1. (Privacy implications) Any website (not just only Kopal profiles) may know about signed Kopal Identity by querying the server.
