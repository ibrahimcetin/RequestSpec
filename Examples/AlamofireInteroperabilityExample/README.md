# Alamofire Interoperability Example

A practical example showing how to use RequestSpec with Alamofire for networking.

## What This Does

This example demonstrates how RequestSpec integrates seamlessly with [Alamofire](https://github.com/Alamofire/Alamofire), one of the most popular networking libraries in the Swift ecosystem.

## What's Inside

- **Two integration approaches**: URLRequestConvertible vs manual conversion
- **Three working examples**: GET with structured RequestSpec, POST with conditional modifiers, and direct Request usage
- **Real API calls** to [JSONPlaceholder](https://jsonplaceholder.typicode.com)
- **Best practices** showing validate() and proper error handling

## How to Run

```bash
cd Examples/AlamofireInteroperabilityExample
swift run
```

That's it! The example will execute all API calls and print the results.

## Quick Start

Open `AlamofireInteroperabilityExample.swift` and explore:
- Lines ~40-87: Example demonstrations
- Lines ~97-154: Service layer with Alamofire integration
- Lines ~172+: RequestSpec definitions with two integration patterns

**Key takeaway**: RequestSpec works seamlessly with Alamofire—use whichever integration style fits your needs!

