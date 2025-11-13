# Web Sockets

Web sockets (formally "WebSocket") is a computer communications protocol that provides bidirectional communication over a single TCP pocket. The protocol was standardized in [RFC 6455](https://www.rfc-editor.org/rfc/rfc6455).

Web sockets are distinct from the HTTP protocol but are meant to complement it – it works over ports 80 and 443, and supports HTTP proxies and other intermediaries. HTTP connections can use the "upgrade" header to switch from HTTP to a web socket connection.

Web socket connections are fully duplex, meaning once that connection is established data can be sent bidirectionally in real tiome over the same connection without the need for polling. Servers can proactively push data to clients without an explicit client request.

## Code example

Here's a simple example of how to work with a web socket connection using the `WebSocket` class in Typescript:

```typescript
// Connect to server
const ws: WebSocket = new WebSocket("wss://game.example.com/scoreboard");

// Receive ArrayBuffer instead of Blob
ws.binaryType = "arraybuffer";

// Set event listeners

ws.onopen = (): void => {
  console.log("Connection opened");
  ws.send("Hi server, please send me the score of yesterday's game");
};

ws.onmessage = (event: MessageEvent): void => {
  console.log("Message received", event.data);
  ws.close(); // We got the score so we don't need the connection anymore
};

ws.onclose = (event: CloseEvent): void => {
  console.log("Connection closed", event.code, event.reason, event.wasClean);
};

ws.onerror = (event: Event): void => {
  console.log("Connection closed due to error");
};
```

## Protocol

At a high level, the protocol follows three stages:

1. Opening handshake over an initial HTTP request and response.
2. Frame-based message exchange once the connection is established.
3. Closing handshake; either the server or the client can close the connection.

### Opening handshake

Web socket connections are established using an HTTP handshake. Clients begin the handshake with a request including an `Upgrade` header:

```
GET /chat HTTP/1.1
Host: server.example.com
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==
Origin: http://example.com
Sec-WebSocket-Protocol: chat, superchat
Sec-WebSocket-Version: 13
```

Servers respond with a `101` response signalling a protocol change:

```
HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=
Sec-WebSocket-Protocol: chat
```

### Frame-based messaging

Once the opening handshake is complete, both client and server can begin sending two types of messages back and forth:

- **Data messages**, in text or binary.
- **Control messages** – ping, pong, and close.

Messages are composed of _frames_ with a specific byte structure. Messages can either be bundled into a single frame (unfragmented) or broken up over multiple frames (fragmented).

## Using web sockets in the real world

How are web sockets typically implemented in some real world applications?

### AWS Web Socket API

Amazon Web Services (AWS) most readily support web sockets through the [API Gateway WebSocket APIs](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api.html).

API Gateway handles the connection lifecycle and allows you to route connections to specific backend destinations, like Lambdas and an EKS (Kubernetes) cluster. A complete flow from the edge to a service deployed in your cluster would look like this:

```
API Gateway -> ALB (application load balancer) -> Ingress Controller -> Route specific services
```

### Pushing messages to clients

Because it matches the mental model of the HTTP request/response cycle, it's easy to understand how a server handles messages received from a client. But how do servers proactively _push_ messages to clients in the absence of a triggering client request?

Every open connection you manage with the AWS WebSocket API will have a unique connection ID – this is how you determine what messages should be sent to particular client connections. You have two options with the AWS ecosystem, both of which can be chosen as [Event Bridge](https://aws.amazon.com/eventbridge/) targets to route events to connections:

1. Directly to **API Gateway**. In this approach, you chose an AWS Lambda as your Event Bridge target. _You_ are responsible for implementing a Lambda that tracks open connection IDs (most people store this data in DynamoDB), and identifies which connection a message should be routed to.
2. Via an **AppSync** API destination. In this approach, you configure an Event Bridge rule to target an [AppSync API](https://aws.amazon.com/appsync/) destination. Clients connected to the AppSync API can subscribe to specific GraphQL subscriptions. AppSync handles managing connection IDs and routing a message to the correct client for you.
