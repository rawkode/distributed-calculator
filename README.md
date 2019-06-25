# Monitoring Distributed Systems

## Calculator Example

Explain 😄

- Metrics
- Events
- Centralised Logging
- Structured Logging
- Traces
  - Not Just for Remote Calls! Trace function calls.
    - Be careful with your runtime

### Task 1

Implement, in your teams, your calculator function in the language of your choice.

### Task 2

Add a `/_liveness` endpoint that confirms if you're application is alive. Ping/Pong is fine

### Task 3

Add a `/metrics` endpoint that exposes metrics in Prometheus exposition format

Ensure these metrics are being consumed by Telegraf and inserted into InfluxDB

### Task 4

Deploy all services to Kubernetes

### Task 5

Centralise your logging. You can use InfluxDB/Telegraf, or you can use ELK if you prefer

### Task 6

Add "Fault Injection" into your services and publish those characteristics to InfluxDB (Events)

### Task 7

Add Distributed Tracing with Jaeger
