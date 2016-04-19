**This is a DRAFT, [comments are welcome](http://groups.google.com/group/kopal).**

**Draft status warning** - _This protocol is in concept stage and highly evolving. It may change radically without any backward compatibility. Here, be dragons._

_(TODO: What Kopal Connect really is? Specification, standard or protocol?)_

_(FIXME: Current implementation requires that server should be capable of accepting multiple simultaneous requests. Redesign.)_

(Wordings/layout referenced from http://openid.net/specs/openid-authentication-2_0.html)

# Contents #



# Abstract #

Kopal Connect is a set of standards and protocols that let two Kopal Identities talk to each other.

Kopal is decentralised. No central authority must approve or register Kopal Identities. Any end user can freely choose their Kopal Identity and can also switch her Kopal Identity to a different URI with no loss of her social network.

Kopal uses only HTTP(S) requests and responses, which are widely used and therefore does not requires any special capabilities.

Kopal uses XML for information representation, a _de-facto_ standard for information representation on web.

Kopal Connect is an open standard and patent-free, available freely to use for any purpose.

(TODO: Write it more technically) Kopal is not a _best effort before giving up_ (like Ruby language) standard, but rather a _strongly typed_ (like C# language) standard, where protocol gives up and reports error instead of falling back (from specific) to something more general if such conditions occur.

## Relation with Kopal Feed ##

There are two standards in Kopal - Kopal Connect and [Kopal Feed](code_KopalFeed.md). Kopal Connect is a communication (two-way) protocol that governs the communication of two Kopal Identities. While Kopal Feed is a publishing (one-way) specification, which publishes user's profile and social contacts in XML form i.e., machine-readable.
Kopal Connect requires Kopal Feed, while Kopal Feed can be used independent of Kopal.

# Conventions and Definitions #

  1. The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](http://www.ietf.org/rfc/rfc2119.txt).
  1. **User** - Person using Kopal Connect service (In first-person context).
  1. **Friend** - Person using Kopal service (In third-person context).
  1. **Requester** - User who is requesting a Kopal Connect request.
  1. **Responder** - User who is responsing to a Kopal Connect request.
  1. **Kopal Identity** (alias **Kopal profile**, **Profile Identity**, **Profile Identity URL**, **Profile URL**, **Profile Homepage**) - URI of the main page of user's Kopal profile. Kopal Identity is unique to each user and uniquely identifies a user.
  1. **Private key/Public key** - Private and public key associated with a Kopal Identity as per [PKCS#1 standard](http://www.rsa.com/rsalabs/node.asp?id=2125).
  1. **Friendship key** - A **secret** key shared between user and a friend. This key is used to authenticate that the request really came from the friend. This key is a _lower-case hexadecimal_ number as per RFC 4648 and without `0x` prefix . Key has a varying length between 32 to 64 (inclusive). (DRAFT: (dis)advantages of using varying length?).
  1. **Message** - Subject for which the communication is taking place, example `discovery` message, `friendship request` message etc.

## Example Representation ##

Most of the part of this specification are documented in form of an example of communication taking process between two person named Alice and Bob. There is also another character named Eve of negative characterstics. (Based on general convention of person naming in field of Cryptography. See http://en.wikipedia.org/wiki/Alice_and_Bob).

Alice has her Kopal Identity at - http://alice.example.net/profile/
Bob has his Kopal Identity at - http://bob.example.org/profile/
Eve has her Kopal Identity at - http://eve.example.org/profile/

## Encoding and Data Formats ##

All data (including XML representation) must be encoded in UTF-8.

URIs must be escaped as per guidelines of [RFC 3986](ftp://ftp.isi.edu/in-notes/rfc3986.txt)

## Signature Algorithm ##

_(To be identified. Choose between SHA2 / Whirlpool)._

## Method of Communication ##

As of now, all Kopal Connect communications are done over GET requests. (This is likely to change to be POST or something better.).

All query parameter keys in GET requests are prefixed with `kopal.` and words are separated by a hyphen-minus "-" (U+002D) sign if needed. Parameters keys are always downcase, and should be normalised so by applying a function for the purpose (example: `String#downcase` in Ruby).

All Kopal Connect requests must accompany the GET request `kopal.connect` whose value is `true`. _(TODO: Value should be the revision number instead)._

If a Kopal Identity responses with a REDIRECT response, user-agent MUST follow the redirection. _(DRAFT: Even for different domain/protocol? Good for delegation?)_

## XML Representation ##

All information in Kopal Connect is represented in XML encoded in UTF-8. Name of root element is `Kopal`.
For root element `Kopal`, attribute `revision` is required, whose value is the revision of implemented Kopal Connect. Attribute `platform` is optional, whose value is the URI of software being used.

# Protocol Overview #

Kopal Connect allows to make a **discovery** on a Kopal Identity, which in turn reveals essential information such as user's name and her public key. A successful **discovery** also guarantees that given URI is really a Kopal Identity.

A **friendship request** can be sent to another Kopal Identity, which in response, responses with _friendship state_ and a _friendship key_ if the **friendship request** is _accepted_.

Further **friendship state update** can be performed using _friendship key_.

# Identification #

Two Kopal profiles are identified uniquely by their URI namely _Kopal Identity_, Authentication of a Kopal Identity is done by an associated Public Key. A Public key is not permanent and can be changed over time. Kopal Connect protocol also allows changing of Kopal Identity to a new URI.

# Kopal Identity #

Encoded in UTF-8, a Kopal Identity can be no longer than 256 bytes.

A Kopal Identity is made up of _name of domain_, _protocol_, _presence of port_, _port number_. Change in any of them results in a different Kopal Identity.

Following is an example of **different** Kopal Identities.

  * http://example.net/
  * http://www.example.net/
  * http://www.example.net:80/
  * http://www.example.net:1234/
  * https://www.example.net/

A Kopal Identity MUST end with a forward slash "/" (U+002F) and MUST NOT have a question mark "?" (U+003F) and a hash "#" (U+0023) as part of URI. In layman's term, in URI hierarchy, a directory should represent Kopal Identity not a file. Also, Kopal Identity should not have any GET requests (query string) or anchors.
For simplicity of coding, Kopal Identity can not have "?" and "#" even in escaped form.

Example of **valid** Kopal Identities -

  * http://www.example.net/
  * http://www.example.net/profile/

Example of **invalid** Kopal Identities -

  * http://www.example.net/profile.php?user=1234
  * http://www.example.net/profile/?referrer=example.com

## Normalising Kopal Identity ##

  1. If protocol is not present, `http://` should be prefixed.
  1. If there is no trailing forward slash "/" (U+002F) present, one MUST be added, even when the last URI segment contains a full stop "." (U+002E), marking it as a potential file-name and not a directory.

| www.example.net                      | http://www.example.net/                 |
|:-------------------------------------|:----------------------------------------|
| http://www.example.net               | http://www.example.net/                 |
| http://www.example.net/profile       | http://www.example.net/profile/         |
| http://www.example.net/profile.dot   | http://www.example.com/profile.dot/     |

# Kopal Connect Discovery #

A **discovery** request is necessary before all other Kopal Connect requests, as it identifies a valid Kopal Identity and also provides essential information about the Kopal Identity.

## Request ##

### Required parameters ###

| **Parameter** | **Note** |
|:--------------|:---------|
| `kopal.subject` | Value MUST be `discovery` |

## Response ##

An XML response with following elements -

  1. **Discovery** (required)
    1. **KopalIdentity** (required) Url what responder thinks her Kopal Identity is. MUST match with the requester's value of requested Kopal Identity.
    1. **Name** (required) Name of the responsing user.
    1. **PublicKey** (required) Public key of responder.
      1. (attribute) _algorithm_ (required) value (as of now) MUST be "PKCS#1"

## Example ##

  1. Bob performs a discovery on Alice's profile by requesting following URI - http://alice.example.net/profile/?kopal.connect=true&kopal.subject=discovery
  1. Alice responses with following information -

```
  <?xml version="1.0" encoding="UTF-8"?>
  <Kopal platform="kopal.googlecode.com" revision="0.1.draft">
  <Discovery>
    <KopalIdentity>http://alice.example.net/profile/</KopalIdentity>
    <Name>Alice</Name>
    <PublicKey algorithm="PKCS#1">-----BEGIN RSA PUBLIC KEY-----
Big key text here
-----END RSA PUBLIC KEY-----</PublicKey>
  </Discovery>
  </Kopal>
```


# Kopal Connect Friendship Request #

Friendship between two Kopal Identities starts with a **friendship request**. In a **friendship request**, requester generates a _friendship key_ and sends a **friendship request** message to friend. Friend now MUST reply with a valid _friendship state_.

For a list of valid _friendship states_, please see [#Kopal\_Connect\_Friendship\_state](#Kopal_Connect_Friendship_state.md)

## Request ##

### Required parameters ###

| **Parameters** | **Note** |
|:---------------|:---------|
| `kopal.subject` | Value MUST be `friendship-request` |
| `kopal.identity` | Kopal Identity of requester |

## Response ##

A valid friendship state response. Please see _Response_ section in [#Kopal\_Connect\_Friendship\_State](#Kopal_Connect_Friendship_State.md).

## Example ##

Bob wants to send a friendship request to Alice.

  1. Before sending a friendship request to Alice, Bob first adds Alice to his friend's list with _friendship state_ as **waiting** and generates a _friendship key_ for Alice.
  1. Bob also saves Alice's profile by visting her [Feed](Kopal.md).
  1. Bob now sends a _friendship request_ to Alice by requesting the URL - http://alice.example.net/profile/?kopal.connect=true&kopal.subject=friendship-request&kopal.identity=http://bob.example.org/profile/
  1. Alice now checks if Bob is already her friend.
    1. If so, she responds with Kopal Error with ID 0x1201 (duplicate friendship request).
    1. Otherwise,
      1. She sends a discovery request to Bob's Kopal Identity. She proceeds only when she gets a valid public key from discovery request.
      1. She now sends a **friendship state** request to Bob's Kopal Identity and retrieves _encrypted friendship key_ and _friendship state_. She proceeds when _friendship state_ is ONLY **waiting**. If _friendship state_ is not _wating_ but is _friend_, _pending_, _none_ or _rejected_, she reports an error 0x1202 (Invalid friendship state) or else 0x1203 (Unknown friendship state). (COMMENT: _Friendship key_ should be generated by requester and not responder, and it should not be given by GET request to responder by requester, but rather responder should retrieve the key by sending a _friendship state_ to requester's Kopal Identity. responder now can ensure that requester really meant to sent the friendship request (It doesn't matter who requested the _friendship request_ on Alice's profile, whether Bob himself, or Eve on behalf of Bob). Also if Bob only sent a friendship request and assuming his software are working correctly, the _friendship state_ can only be _waiting_ for Alice's Kopal Identity.).
      1. She now decrypts the encrypted friendship key with her private key and makes sure that it decrypts to a valid _friendship key_.
      1. She may now reject or accept Bob's friendship request.
      1. If she accepts,
        1. If Alice prefers to verify manually before adding a friend, friendship state is assigned _pending_ else _friend_.
        1. She now gets Bob's profile by visiting his [Feed](Kopal.md) and saves Bob in her friend's list.
      1. She now responds with a _friendship state_ response, where _friendship state_ value MUST be in _friend_, _pending_ or _rejected_.
      1. Bob now checks responded friendship state. If it is _friend_, Bob updates Alice's _friendship state_ in his database to _friend_. If responded state is _pending_, Bob leaves it as _waiting_. If respose state is _rejected_, Bob deletes Alice from his friend list. (TODO: What if it is invalid (ex: none) or unknown?).
      1. From now on (i.e., excluding friendship-request) all friendship related communications require the _friendship key_.


# Kopal Connect Friendship Update #

Friendship state can be updated using `friend-update` message.

## Request ##

### Required parameters ###

| **Parameter** | **Note** |
|:--------------|:---------|
| `kopal.subject` | Value MUST be `friendship-update` |
| `kopal.friendship-state` | New friendship value, (at present) can only be `friend` or `rejected` |
| `kopal.identity` | Kopal Identity of the reqester |
| `kopal.friendship-key` | Shared friendship key |

## Response ##

A valid friendship state response. Please see _Response_ section in [#Kopal\_Connect\_Friendship\_State](#Kopal_Connect_Friendship_State.md).

## Example ##

Alice wants to change _friendship state_ of Bob from _pending_ to _friend_.

  1. Alice requests Bob's `friendship-update` URI - http://bob.example.org/profile/?kopal.connect=true&kopal.subject=friendship-update&kopal.friendship-state=friend&kopal.identity=http://alice.example.net/profile/&kopal.friendship-key=string-of-friendship-key
  1. Bob now may accept of reject the request.
    1. If he accepts, he checks for following.  If verficiation fails, he reports a Kopal Error or else replies with a `friendship-state`
      1. Kopal Identity of Alice. Is she in his friend list or not?
      1. Friendship key. Is this valid?
      1. Can update the `friendship state` to new one?
  1. Alice now makes sure that the `friendship state` in response is same as requested. If yes, she updates her databases too. (TODO: What if not?).

# Kopal Connect Friendship State #

Friendship state can be known or verified by requesting a `friendship state` message. These _friendship state_ messages can be anonymous, i.e., anyone can request a _friendship state_ messge. However, for privacy reasons, responder may require identification.

## List of Friendship States ##

  1. `none`
  1. `rejected`
  1. `waiting`
  1. `pending`
  1. `friend`

**none** - _(no friendship)_ This is the default friendship state between any two Kopal Identities, it means that two Kopal Identities are not in friendship at the present moment. (They might have been in past).
**rejected** - _(no friendship)_ This is a temporary _friendship state_. By sending this _friendship state_ a user ends a friendship, after which the _friendship state_ changes to `none`. User may also chose this to be a permanent _friendship state_ for Kopal Identities for which she wants to block _friendship requests_.
**waiting** - _(one-way / implied friendship)_ User has sent the _friendship request_ and is _waiting_ for approval from friend's Kopal Identity.
**pending** - _(one-way / implied friendship)_ User (machine) has recieved the _friendship request_ and is waiting for a manual approval from the user (human).
**friend** - _(two-way / real friendship)_ Two Kopal Identities have agreed to be friend of each other.

## Request ##

### Required Parameters ###

| **Parameter** | **Note** |
|:--------------|:---------|
| `kopal.subject` | Value MUST be _friendship-state_ |
| `kopal.identity` | Kopal Identity of friend whose friendship state is to be known |

Anyone can request the _friendship state_, however it is possible that responder does not allow anonymous quries and may require identification. In this case responder REQUIRES following _optional_ parameters or returns error 0x1211 (identification required) if they are not presnent.

### Optional Parameters ###

| **Parameter** | **Note**|
|:--------------|:--------|
| `kopal.requesting-identity` | Kopal Identity of the requester. |
| `kopal.friendship-key` | Friendship key of requester. |

(TODO: Chicken-egg problem for friends with `waiting` state, since they must obtain _friendship key_ from a _friendship state_ request, and they need a _friendship key_ to make the request. One solution may be to make `waiting` friendship state be always shown without identification. Or (with much complications) give friend a temporary access key while requesting friendship.).

## Response ##

An XML response with following elements -

  1. **FriendshipState** _(required)_
    1. (attribute) **state** _(required)_ Friendship state of requester.
    1. (attribute) **identity** _(required)_ Kopal Identity of requester as seen by responder. MUST match with Kopal Identity of requester as seen by requester.
  1. **FriendshipKeyEncrypted** _(optional)_ Required only when the _friendship state_ is _waiting_. Contains the _friendship key_ encrypted by requester's public key and encoded in **Base64**. So that requester can decrypt it with her private key to get the _friendship key_.

## Example ##

### Example 1 ###

Eve wants to verify the friendship state of Bob and alice.

  1. Eve requests the URL - http://alice.example.net/profile/?kopal.connect=true&kopal.subject=friendship-state&kopal.identity=http://bob.example.org/profile/
  1. Alice, if allows anonymous _friendship state_ requests, responses with -
```
  <?xml version="1.0" encoding="UTF-8" ?>
  <Kopal revision="0.1.draft" platform="kopal.googlecode.com">
    <FriendshipState state="friend" identity="http://bob.example.org/profile/">
  </Kopal>
```

### Example 2 ###

Bob has recently sent a _friendship request_ to Alice, and Alice now wants to verify it before adding Bob to his friend. (Refer [#Kopal\_Connect\_Friendship\_Request](#Kopal_Connect_Friendship_Request.md))

  * Alice requests - http://bob.example.org/profile/?kopal.connect=true&kopal.subject=friendship-state&kopal.identity=http://alice.example.net/profile/
  * Bob responses with -
```
  <?xml version="1.0" encoding="UTF-8" ?>
  <Kopal revision="0.1.draft" platform="kopal.googlecode.com">
    <FriendshipState state="waiting" identity="http://alice.example.net/profile/">
    <FriendshipKeyEncrypted>Friendship key encrypted by Alice's public key and encoded in Base64</FriendshipKeyEncrypted>
  </Kopal>
```

# Kopal Connect Signin Request #

A Kopal profile may request another Kopal profile to authenticate itself. This happens when a visitor is visiting some Kopal profile and she wants to signin to her Kopal Identity.

## Request ##

## Required parameters ##

| **Parameter** | **Note** |
|:--------------|:---------|
| `kopal.subject` | Value MUST be _signin-request_ |

## Optional Parameters ##

| **Parameter** | **Note** |
|:--------------|:---------|
| `kopal.returnurl` | URL where profile SHOULD redirect after successful signin, optionally appending `kopal.visitor` parameter |

## Example ##

Bob is browsing Alice's Shoutbox page (at http://alice.example.net/profile/home/comment/) as an anonymous user and wants to signin.

  * Bob asks Alice's profile to make him signin. (Can be done by clicking on "Sign-In" from Kopal Ribbon at bottom-right of any Kopal page).
  * Alice's profile now redirects to http://bob.example.org/profile/?kopal.connect=true&kopal.subject=signin-request&kopal.returnurl=http://alice.example.net/profile/home/comment/
  * Bob now signs-in on his profile and then gets redirected to http://alice.example.net/profile/home/comment/?kopal.visitor=http://bob.example.org/profile/
  * Alice's profile now signs-in Bob as a visitor using [#Kopal\_Connect\_Signing](#Kopal_Connect_Signing.md) protocol.

# Kopal Error #

For some very specific error in protocol, it becomes necessary for the machine to understand the nature of the error. While machines can not understand an error message represented in a human language, they surely can understand _error codes_.

For a list of Error codes please see - http://code.google.com/p/kopal/source/browse/lib/kopal/exception.rb

## Response ##

An XML representation with following elements -

  1. **KopalError** _(required)_
    1. **ErrorCode** _(optional)_ - Error code in hexadecimal notation (starting with `0x`) if available.
    1. **ErrorMessage** _(required)_ - Error message.

## Example ##

Bob sends a _friendship request_ to Alice, but Alice and Bob are already friend (or in process of), Alice responses with a error message -
```
  <?xml version="1.0" encoding="UTF-8" ?>
  <Kopal revision="0.1.draft" platform="kopal.googlecode.com">
    <KopalError>
      <ErrorCode>0x1201</ErrorCode>
      <ErrorMessage>Duplicate friendship request.</ErrorMessage>
    </KopalError>
  </Kopal>
```

# Draft (RFC) #

  * A header `X-KOPAL-IDENTITY` at http://www.example.net/ with value http://www.example.net/profile/
or a `<meta />` tag for the same.
  * A header `X-KOPAL-FEED-URL` at http://www.example.net/ with value http://www.example.net/profile/feed.kp.xml
or a `<meta />` tag for the same.
  * Integration with **Yadis**, **FOAF**, **XFN**, **OpenSocial** etc.

# See Also #

  * [Kopal\_Feed](Kopal_Feed.md)