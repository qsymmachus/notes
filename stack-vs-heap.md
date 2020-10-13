Stack vs. Heap Memory
=====================

A software program uses two regions of memory, the __stack__ and the __heap__.

Stack
-----

The stack is used for static memory allocation, and as the name suggests it is a last-in first-out (LIFO stack).

* Due to its structure, data retrieval is __fast__ because there is no lookup required, you just pop the topmost block from the stack.
* But this also means that data stored on the stack must be __finite__ and __static__; the size of the data must be known at compile time.
* Multi-threaded applications can have their own __stack per thread__.
* Memory management of the stack is __simple__ and is handled by the OS. When a block is popped from the stack, that memory is cleared.
* There is a __size limit__ of a value that can be stored on the stack in most languages.
* Data typically stored on the stack include __local variables, pointers, and function frames__.

Heap
----

The heap is used for dynamic memory allocation, and the program needs to look up data in the heap using pointers.

* It is __slower__ than the stack because a lookup must be performed to retrieve data from the stack.
* However data with __no size limit__ and data with __dynamic size__ (not known at compile time) can be stored here.
* Heap is __shared__ across program threads.
* Due to its dynamic nature memory management is __harder__ in the heap. Some languages require manual memory management, others rely on automated processes like garbage collection.
* Data typically stored on the heap include __reference types__ like __strings, objects, maps__ and other complex data structures of unfixed size.

