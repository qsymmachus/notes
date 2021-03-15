Singular Update Queue
---------------------

* [https://martinfowler.com/articles/patterns-of-distributed-systems/singular-update-queue.html](https://martinfowler.com/articles/patterns-of-distributed-systems/singular-update-queue.html)

A singular update queue allows multiple concurrent clients to safely update state on a single node without locks.

To do this, implement a work queue and a single thread working off this queue. This guarantees that only one update operation will be performed at a time, and in the order they are received from clients.

Here's an example implementation, with a singular update queue implemented using a channel:

```go
// Underlying implementation of the key/value store.
//
// `data` is our backing key/value map. `updates` is a singular update queue,
// implemented as a channel, that receives update messages and applies them
// to the store.
type kvStore struct {
	data    map[interface{}]interface{}
	updates chan (update)
}

// Enum of all types of updates to the store.
type updateType uint8

const (
	set updateType = 0
)

// Request to update the state of the store.
type update struct {
	updateType updateType
	key        interface{}
	value      interface{}
	result     chan (updateResult)
}

// The result of an update operation.
type updateResult struct {
	ok  bool
	err error
}
```

This function continually checks for messages received on the `updates` queue:

```go
// Reads updates from the store's singular update queue. This ensures that only
// one update is processed at a time, in the order they're received.
func (s *kvStore) readUpdates() {
	for update := range s.updates {
		switch update.updateType {
		case set:
			s.data[update.key] = update.value
			update.result <- updateResult{true, nil}
		default:
			err := fmt.Errorf("Unknown update type %d", update.updateType)
			update.result <- updateResult{false, err}
		}
	}
}
```

The `Set` function simply sends a message to the queue, and waits for a response:

```go
// Sets a key/value pair in the store. Returns an error if it failed.
func (s *kvStore) Set(key interface{}, value interface{}) (err error) {
	update := update{0, key, value, make(chan (updateResult))}
	s.updates <- update
	result := <-update.result

	if !result.ok && result.err != nil {
		return result.err
	}

	return nil
}
```

The `readUpdates` function runs in background:

```go
// Instantiates an empty store and starts a goroutine to read
// messages sent to the `updates` queue.
func NewStore() *kvStore {
	store := kvStore{
		data:    make(map[interface{}]interface{}),
		updates: make(chan (update)),
	}

	go store.readUpdates()

	return &store
}
```

## Advantages

Eliminating the need for locks to handle concurrent requests can be helpful if update operations are expensive. Singular update queues also make it easy to implement _backpressure_ – if the update queue is getting too full, we can easily detect that situation and reject update requests to relieve pressure.

## Examples

* [etcd](https://github.com/etcd-io/etcd) uses a single goroutine working off a request channel to update its state.
* You implemented a singular update queue in your [kv](https://github.com/qsymmachus) project.
