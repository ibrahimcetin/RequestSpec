# URLSession Interoperability Example

A practical example showing how to use RequestSpec with URLSession for networking.

## What This Does

This example demonstrates how RequestSpec integrates with existing URLSession codebases. Perfect for teams that want type-safe requests without adopting new networking protocols.

## What's Inside

- **Direct URLSession integration**: Works with your existing URLSession code
- **Manual conversion**: Shows how to convert RequestSpec/Request to URLRequest using `urlRequest(baseURL:)`
- **Three working examples**: GET with structured RequestSpec, POST with conditional modifiers, and direct Request usage
- **Real API calls** to [JSONPlaceholder](https://jsonplaceholder.typicode.com)
- **Best practices** showing response validation and error handling

## How to Run

```bash
cd Examples/URLSessionInteroperabilityExample
swift run
```

That's it! The example will execute all API calls and print the results.

## Quick Start

Open `URLSessionInteroperabilityExample.swift` and explore:
- Lines ~40-87: Example demonstrations
- Lines ~97-188: Service layer with direct URLSession usage
- Lines ~205+: RequestSpec definitions

**Key takeaway**: RequestSpec works seamlessly with existing URLSession code—just convert to URLRequest and send!
