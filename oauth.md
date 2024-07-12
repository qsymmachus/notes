OAuth2 in a Nutshell
====================

Since you forget the details of how OAuth2 works every 6 months, here they are for posterity.

In the simplest possible terms, OAuth is an open standard for access delegation, which allows users to grant websites or application access to their information on other websites but without giving them the passwords.

Key concepts
------------

* __Resource Server__:  services that own data. A resource protects its data by defining an OAuth scope required to retrieve data. Resources have a _resource owner_ – that is, the user initiating an authorization flow.
* __Clients__:  clients that attempt to access a user's data on their behalf. A client identifies itself to the authorization server by providing its `client_id` and `client_secret`.
* __Authorization Server__: Handles the exchange of an auth grant for an access token. Sometimes the authorization server and resource server are one and the same. Often however, they are distinct, and authorization is handled by a third party.
* __Access Token__: Token string used when making authenticated requests to a resource.

Authorization flow
------------------

```
     User           Client           Authz Server           Resource Server
     ----           ------           ------------           ---------------
       |               |                  |                       |
 start flow ---------->|                  |                       |
       |               |                  |                       |
       |            redirect ------------>|                       |
       |               |                  |                       |
       | < --------------------- ask for consent                  |
       |               |                  |                       |
    consent ----------------------------->|                       |
       |               |                  |                       |
       |<--(redirect)--|<-------redirect w/authz code             |
       |               |                  |                       |
       |      send code + secret -------->|                       |   
       |               |                  |                       |
       |               |<----------- access token                 |
       |               |                  |                       |
       |      request for data ------------(access token)-------->|
       |               |                  |                       |
       |               |<----------------------------------------data 
```

* The user (resource owner) wants to grant a client permission to access data on the resource server.
* The client redirects the user's browser to the authorization server. The request includes:
  * The client ID
  * A redirect URI (where should the authz server redirect the user after consent is granted)?
  * Reponse type (the type of response the client expects to receive from the authz server, most commonly this is "code", a one-time authz code).
  * A list of scopes (they determine what specifically the client is asking permission to do with the resource server).
* The authz server verifies the user's session, prompting a login if necessary. It then asks the user for permission using a consent form, based on the scopes sent by the client.
* The user consents to the request.
* The authz server redirects the user back to the client's page using the redirect URI that was provided earlier. It also includes an __authorization code__ in the callback payload.
* The client contacts the authz server directly (not using the user's browser), and securely exchanges the temporary authorization code for a permanent __access code__. The request is authenticated using the client ID and client secret.
* Now that it has an access token (which is opaque to the client), it can use it to authorize requests to the resource server. The resource server validates the scopes tied to the access token to control what the client is actually permitted to do.

It's important to note that long before this flow was initiated, the client and authorization server had to establish a working relationship. The authz server generated a client ID and client secret (sometimes called an 'app ID' and 'app secret') for the client.

Scopes
------

A resource protects itself by requiring a specific __scope__ to be present that relates to the data/action it is providing, for example: 

* `member.identity.full-name` - a scope that protects a user’s full name 
* `member.identity.address` - a scope that protects a user’s address

In other words, scope provide an _authorization_ layer in addition to the authentication layer OAuth2 already provides.

Specific scopes are tied to each access token granted by an authorization server.


Access Tokens in detail
-----------------------

The Oauth spec _does not_ define what an access token should actually look like. In practice, [JSON Web Tokens](https://jwt.io/) (JWTs) are most common.

JWT access tokens usually contain:

* Identity of the client
* Scopes
* Expiry date
* User claims

Example access token:

```
Header (algorithm & token type)
  "kid": "jwt-remote-key", 
  "alg": "RS512" 

Data and Payload
  "aud": "mono",
  "scope": [ "openid","registration_step_3", "offline_access" ],
  "iss": "auth.creditkarma.com",
  "exp": 1519952764,
  "iat": 1519951864,
  "jti": "6dcda840-6fc3-493c-bb9d-9afd0e56af53"

Signature
  HMACSHA256(base64UrlEncode(header) + "." +
  base64UrlEncode(payload),secret)
```

* `aud`: the client ID the token was generated for.
* `scope`: a list of string names that define what resources we can access.
* `iss`: the issue of the token.
* `exp`: the expiry date.
* `iat`: the date the token was created.
