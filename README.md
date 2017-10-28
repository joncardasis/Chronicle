<div align="center">
  <img src="/Assets/Chronicle_Icon.png" alt="Chronicle" width=460px>
  <p><em>An iOS version checker</em></p>
</div>

>Chronicle is a version compatibility checker for iOS applications.

## How it works
1. Host a properly formatted `json` file on your own server. Read more on formatting from the [Payload.md](Payload.md).
2. In the `application:didFinishLaunchingWithOptions:` (or likewise) method of your app's AppDelegate check for version compliance and handle accordingly.

## Example
```Swift

```


## JSON Payload Format
A formatted JSON payload served via your own server.

- See [ChronicleTests/JSON](ChronicleTests/JSON) for examples of the payload format.
- See [Payload.md](Payload.md) for formatting requirements
