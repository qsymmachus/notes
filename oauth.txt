OAuth2 in a Nutshell
====================

Since you forget the details of how OAuth2 works every 6 months, here they are for posterity.

In the simplest possible terms, OAuth is an open standard for access delegation, which allows users to grant websites or application access to their information on other websites but without giving them the passwords.

Key concepts
------------

1. __Resources__:  services that own data. A resource protects its data by defining an OAuth scope required to retrieve data.
2. __Clients__:  clients that attempt to access a user's data on their behalf. A client identifies itself by providing its `client_id` and `client_secret`.
3. __Access Token__: Token string used when making authenticated requests to a resource.

Authorization flow
------------------

```
     Client           User           Auth Server           Resource Server
     ------           ----           -----------           ---------------
       |               |                  |                       |
 auth request--------->|                  |                       |
       |               |                  |                       |
       |<----------auth grant             |                       |
       |               |                  |                       |
  auth grant----------------------------->|                       |
       |               |                  |                       |
       |<---------------------------access token                  |
       |               |                  |                       |
 access token---------------------------------------------------->|
       |               |                  |                       |
       |<--------------------------------------------------resource (data)               
       |               |                  |                       | 
```


Access Tokens in detail
-----------------------

Access tokens contain:

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

Scopes
------

A resource protects itself by requiring a specific __scope__ to be present that relates to the data/action it is providing, for example: 

* `member.identity.full-name` - a scope that protects a user’s full name 
* `member.identity.address` - a scope that protects a user’s address

In other words, scope provide an _authorization_ layer in addition to the authentication layer OAuth2 already provides.

