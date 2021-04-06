Go Diagnostics & Profiling
==========================

The Go standard library provides excellent tooling to diagnose logic and performance problems with your programs. Here's a quick summary of how to incorporate basic tracing/profiling in a Go program running an HTTP or gRPC API.

For more details: [https://golang.org/doc/diagnostics](https://golang.org/doc/diagnostics)

Setting up diagnostics
----------------------

If you have a server, you can enable tracing and profiling endpoints by adding the following to your main function:

```go
package main


import (
  core_runtime "runtime"
  _ "golang.org/x/net/trace" // tracing package
  _ "net/http/pprof" // profiling package
)

func main() {
  core_runtime.SetBlockProfileRate(1)
  http.ListenAndServe(":10002") // expose tracing/profiling endpoints on this port
}
```

The net/http/pprof package registers its handlers to the default mux by default, but you can also register them yourself by using the handlers exported from the package:

```go
func main() {
	mux := http.NewServeMux()
	mux.HandleFunc("/custom_debug_path/profile", pprof.Profile)
	log.Fatal(http.ListenAndServe(":10002", mux))
}
```

Using diagnostics
-----------------

With tracing enabled, the following HTTP endpoints will be exposed (all examples links below assume you are running locally and chose port number `10002`):

* [http://localhost:10002/debug/events](http://localhost:10002/debug/events) – event tracing
* [http://localhost:10002/debug/requests](http://localhost:10002/debug/events) – request tracing
* [http://localhost:10002/debug/pprof/]([http://localhost:10002/debug/pprof/]) – lists a range of profiling dumps, like heap and goroutine profiles

You can drill-down into profiles retrieved from from `debug/pprof` endpoints using `go tool pprof`, which opens an interactive tool for examining profiles. For example, to examine a heap profile:

```
▶ go tool pprof http://localhost:10002/debug/pprof/heap
Fetching profile over HTTP from http://localhost:10002/debug/pprof/heap
Saved profile in /Users/john.olmsted/pprof/pprof.alloc_objects.alloc_space.inuse_objects.inuse_space.005.pb.gz
Type: inuse_space
Time: Jan 15, 2021 at 11:30am (PST)
Entering interactive mode (type "help" for commands, "o" for options)
(pprof) 
```

You can also use a `pprof` web UI instead. Download a profile you want to dive into, for example a heap dump:

```
curl -sK -v http://localhost:10002/debug/pprof/heap > ./heap-dump.out
```

Then spin up a server where you can access the web UI, in this example at `http://localhost:8080`:

```
go tool pprof -http=:8080 ./heap-dump.out
```

Simulating load
---------------

If you need to simulate load to generate diagnostic and profiling data, `hey` is a great option ([https://github.com/rakyll/hey](https://github.com/rakyll/hey)).

To throw 100 requests, with a maximum of 10 concurrent requests, at an HTTP endpoint:

```
hey -n 100 -c 10 http://localhost:10000/my/neat/endpoint
```
