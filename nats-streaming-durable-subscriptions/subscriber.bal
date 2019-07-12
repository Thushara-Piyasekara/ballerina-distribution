import ballerina/encoding;
import ballerina/io;
import ballerina/log;
import ballerina/nats;

// Creates a NATS connection.
nats:Connection conn = new("localhost:4222");

// Initializes the NATS Streaming listener.
listener nats:StreamingListener lis = new(conn, "test-cluster", "c0");

// Binds the consumer to listen to the messages published to the 'demo' subject.
@nats:StreamingSubscriptionConfig {
    subject: "demo",
    durableName: "sample-name"
}
service demoService on lis {
    resource function onMessage(nats:StreamingMessage message) {
       // Prints the incoming message in the console.
       io:println("Message Received: " + encoding:byteArrayToString(message.getData()));
    }

    resource function onError(nats:StreamingMessage message, nats:NatsError errorVal) {
        error e = errorVal;
        log:printError("Error occurred: ", err = e);
    }
}
