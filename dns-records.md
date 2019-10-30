DNS Records Cheatsheet
======================

Defining DNS Records
--------------------

### Type

`A`, `AAAA`, `CNAME`, `ALIAS`, `ANAME`, `TXT`, `MX`

### Host

The root of the domain (`@` or blank) or a subdomain (`www`, `admin`, etc) where you want to place the record.

### Value

What the host should point to. 
Can be an IP address (`A`, `AAAA`), 
another domain (`CNAME`, `ALIAS`, `ANAME`, `MX`),
or an arbitrary value (`TXT`).

### Priority

Only for MX records – what email provider should be given priority?

### TTL

Time to live for the record. Shorter TTLs are best for values that change often, longer TTLs will resolve faster for better performance.

Most Common Types
-----------------

### A

Maps a domain name to an IPv4 address.

```
example.com => 127.0.0.1
```

### AAAA

Maps a domain name to an IPv6 address.

```
example.com => ::1
```

### CNAME

Maps a domain name to another domain name. _Never do this on the root_ (`@`), because that will prevent you from creating any more records for that host. You can only have one `CNAME` record per host.

```
www.example.com => example.com
```

### ALIAS

Maps a domain name to another domain name. Unlike `CNAME`, this is safe to do on the root.

```
example.com => myapp.heroku.com
```

### ANAME

Another name for `ALIAS` that some providers support.

```
example.com => myotherapp.heroku.com
```

### TXT

Sets arbitrary data as the value of your domain record.

```
@ => wow-holy-crap
```

### MX

Sets custom email for your domain.

```
@ => ASPMX.L.GOOGLE.COM 1
```

