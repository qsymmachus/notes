GPG CHEATSHEET
==============

See: 
* https://www.gnupg.org/gph/en/manual.html
* https://alexcabal.com/creating-the-perfect-gpg-keypair/


Generating a Key
----------------

Advice for key generation changes all the time. If you're generating a new key, read up on 
the latest best practices first. In general, though, new keys should:

1. Use as many bits as possible,
2. Be self-signed (see the "Signing" section below),
3. Have an expiration date (you can always extend it later),
4. Have a revocation certificate.

```
gpg --full-generate-key
```
* Use RSA and RSA
* Use key size 4096
* Key should expire in one year


Managing Keys
-------------

`gpg --list-keys`

`gpg --delete-key <key id>`


Exchanging Keys
---------------

This exports the public key in binary format:

`gpg --output my-key.gpg --export <key id>`

Adding the 'armor' option exports the public key in a human-readable format:

`gpg --output my-key.gpg --armor --export <key id>`

`gpg --import friends-key.gpg`


Signing a Key
-------------

When you recieve a new public key, you should take steps to validate it.
Take a look the the key's fingerprint and confirm it matches what you expect with
The key's owner:

`gpg --edit-key <key id>`

Once editing the key, check the fingerprint with this command:

`> fpr`

To validate it, you sign it:

`> sign`

!!! NB !!!
You should also sign YOUR OWN key to prevent attackers from tampering with the key. An attacker
could changed the user id (uuid), or replace a public encryption subkey with their own key. When
data is signed by a private key, the corresponding public key is bound to the signed data. In other
words, only the corresponding public key can be used to verify the signature and ensure that the
data has not been modified. A public key can be protected from tampering by using its corresponding
private master key to sign the public key components and user IDs, thus binding the components to
the public master key. Signing public key components with the corresponding private master signing 
key is called SELF-SIGNING, and a public key that has self-signed user IDs bound to it is called
a CERTIFICATE.


Encrypting and Decrypting Files
-------------------------------

Files are encrypted with the recipient's keypair's public key:

`gpg --output encrypted-file.gpg --encrypt --recipient <key id for recipient's public key> file`

Files are decrypted with your own keypair's private key (assuming you are the recipient!):

`gpg --output file.gpg --decrypt encrypted-file.gpg`


Editing a Key
------------

`gpg --edit-key <key id>`

Add a subkey

`> addkey`

Add another user id

`> adduid`

To select a subkey. Run the same command again to deselect.

`> key <number of the key>`

To select a uid. Run the same command again to deselect.

`> uid <number of the uid>`

To delete a key (after selected):

`> delkey`

To delete a uid (after selected):

`> deluid`


Update a Key's Expiration Time
------------------------------

`gpg --edit-key <key id>`

As is, extends the public key's expiration date.

`> expire`

To extend subkey expirations, select them first.

```
> key <number of the key>
> expire
```

When you're done, don't forget to save:

```
> save
```

Create a Revocation Certificate
-------------------------------

`gpg --output my-rev-cert.gpg --gen-revoke <key id>`

To use the certificate:

`gpg --import my-rev-cert.gpg`


Sending a Key to a Key Server
-----------------------------

`gpg --keyserver <key server uri> --send-key <key id>`

NB: if you send a revoked key to a server, it will be updated as revoked!

