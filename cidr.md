CIDR Notation
=============

CIDR notation is a convenient way to represent ranges of IPs. Assuming you're using IPv4, CIDR notation uses the following syntax:

```
a.b.c.d/n
```

Where `a.b.c.d` represents the starting address, and `n` is the number of bits in the network prefix, out of a total 32 bits in the address. To provide a concrete example:

```
206.134.168.0/24
```

Here we have 24 bits in the network prefix. This means we have `32 - 24 = 8` bits for the host address space. 

```
2^32-n hosts
=
2^8 hosts
=
256 hosts in this CIDR range!
```

In this case, 206.134.168.0/24 represents all hosts between 206.134.168.0 – 206.134.168.255.

