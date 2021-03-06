<div align="center">
  <img src="/Assets/Chronicle_Icon.png" alt="Chronicle" width=460px>
  <p><em>An iOS version checker</em></p>
  <span>
    <img src="https://img.shields.io/badge/Swift-4-yellow.svg" alt="Swift 4">
    <img src="https://img.shields.io/badge/platform-iOS-lightgray.svg" alt="iOS Platform">
    <img src="https://img.shields.io/badge/Carthage-✔-green.svg" alt="Carthage Compatible">
    <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License">
  </span>
</div>

>Chronicle is a version compatibility checker for iOS applications.

## How it works
1. Host a properly formatted `json` file on your own server. Read more on formatting from the [Payload.md](Payload.md).
2. In the `application:didFinishLaunchingWithOptions:` (or likewise) method of your app's AppDelegate check for version compliance and handle accordingly.

## Example
`Chronicle` provides 3 block callbacks which are all optional callbacks.
> (1) Minimum version found, (2) recommended version found, (3) error occurred.

**Example**
```Swift
Chronicle().checkForUpdates(from: url,
      requiredVersion: { (version, isMinimumVersionSatisfied, notificationType) in
        if notificationType == .once {
          if !isMinimumVersionSatisfied {
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
                    Attached message: \(version.message)
                    You should go and download it!
                    """)
            }

        }) { (error) in
            // Usually don't want to display anything to user at this point
        }
```

Check out the *ChronicleExample* build target for more.

## Why Chronicle?
Obtaining current version info from the App Store directly is the *best* way to ensure your users are receiving notifications for app versions which actually exist.

However, this project serves as a **force-upgrade** module for you to modify the required versions at any time via a simple json file.

For example, this is useful if an API breaking change was implemented and users who run versions less than 2.0 would be hitting incorrect endpoints.


## JSON Payload Format
A formatted JSON payload served via your own server.

- See [ChronicleTests/JSON](ChronicleTests/JSON) for examples of the payload format.
- See [Payload.md](Payload.md) for formatting requirements

## License
Chronicle is available under the MIT license. See the LICENSE file for more info.
