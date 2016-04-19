With a distributed system, while a profile can authenticate a user using OpenID, it should also be able to prove that a "comment" was posted by that user. So, simply signing-in with OpenID will not work.

For example, Eve's profile has a comment from Bob. How can Alice verify that it was Bob only who posted the comment? It is possible that Eve wrote the message herself and added Bob as author. Eve must be able to prove that the message was posted by Bob only.

This requires that while Bob can sign-in via OpenID, while posting comment, the comment must gets signed by a key which only Bob can posses. Also this means that Bob can not sign in using a simple OpenID and it must be a Kopal Identity. Also it means that people must be authenticated before posting a comment.

Better ideas?