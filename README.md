<div align="center">
  <img src="/Assets/Chronicle_Icon.png" alt="Chronicle" width=460px>
  <p><em>An iOS version checker</em></p>
</div>

>Chronicle is a version compatibility checker for iOS applications.

## How it works
1. Host a properly formatted `json` file on your own server. Read more on formatting from the [Payload.md](Payload.md).
2. In the `application:didFinishLaunchingWithOptions:` (or likewise) method of your app's AppDelegate check for version compliance and handle accordingly.

## Example
`Chronicle` provides a 3 block callback which are all optional callbacks.
> (1) Minimum version found, (2) recommended version found, (3) error occurred.

**Example**
```Swift
Chronicle().checkForUpdates(from: url,
      requiredVersion: { (version, isMinimumVersionSatisfied, notificationType) in
        if notificationType == .once {
          if !isMinimumVersionSatisfied { //notificationType guaranteed to be `.always`
            print("""
                  Version \(version.version) is available.
                  You are required to download this version to continue using this application.
                  Visit \(version.storeUrl) to upgrade.
                  """)
          }
        },
        recommendedVersion: { (version, isMinimumVersionSatisfied, notificationType) in
            if !isMinimumVersionSatisfied {
              print("""
                    Version \(version.version) is available!
                    You should go and download it!
                    """)
            }

        }) { (error) in
            // Usually don't want to display anything to user at this point
        }
```

Check out the *ChronicleExample* build target for more.


## JSON Payload Format
A formatted JSON payload served via your own server.

- See [ChronicleTests/JSON](ChronicleTests/JSON) for examples of the payload format.
- See [Payload.md](Payload.md) for formatting requirements
