# Integration Guide

Thank you for choosing Gini GmbH services and being our partner! This document will guide you through integrating our SDK into your project. We have worked hard in order to make it as easy and convenient as possible. However, if you see anything out of the ordinary of you have any wishes, feel free to write us in GitHub or open an issue!

## How we distribute our SDK

In order to maintain a high level of transparency with our partners, this SDK is open source and released under the permissive MIT license. As main distribution channel, we chose Cocoapods. However, if you don't want to use Cocoapods, you can always build a version yourself, add the source files to your project manually or use git submodules.

### Cocoapods

We chose to use our own `podspec` repository, you you will have to add it as a source to your `PodFile`:

```ruby
source 'https://github.com/gini/gini-podspecs.git'
source 'https://github.com/CocoaPods/Specs.git'

pod "GiniSwitchSDK"
```

Then, in order to add the SDK as a dependency, just run the following command in the terminal:

```bash
$ pod install
```

For more information about that, just go to the [Cocoapods website](http://cocoapods.org).

## Working with The Gini Switch SDK

The Gini Switch SDK is designed to be a self-contained and independent part of your app. Therefore, integrating it is relatively simple. A great resource for reference while doing so, is the example app. It's part of the repository and is a very simple container app that shows how to start, stop and receive information from the SDK.

### Starting the SDK

The SDK is designed to take over the whole app navigation once it's started, assist the user in photographing their document and finally notifying the host app that it's done and it can be dismissed. While that's happening, it uses delegation to periodically inform the hosting app about events that are happening (a page has been uploaded, a new extraction is available, etc.).

```swift
let sdk = GiniSwitchSdk(clientId: "YourClientID", clientSecret: "YourSecret", domain: "gini.net")
sdk.delegate = self
let switchController = sdk.instantiateSwitchViewController()
self.present(switchController, animated: true) {
    // The SDK is active now!
}
```

This is the simplest way to instantiate and show the Switch SDK.

**NOTE:** The `GiniSwitchSdk` is not singleton. You can create several instances. However, you shouldn't have to.

### Dismiss the SDK

```swift
self.dismiss(animated: true, completion: nil)
sdk = nil
```

Just dismiss the view controller you got from the `sdk.instantiateSwitchViewController()` and discard the `GiniSwitchSdk` instance. ARC will take care of the rest.

### Receiving information from the Switch SDK

The Gini Switch SDK uses the Delegate design pattern to notify the host app about events happening as it is running. The protocol contains the following methods:

```swift
public protocol GiniSwitchSdkDelegate: class {

    func switchSdkDidStart(sdk:GiniSwitchSdk)
    func switchSdk(sdk:GiniSwitchSdk, didCapture imageData:Data)
    func switchSdk(sdk:GiniSwitchSdk, didUpload imageData:Data)
    func switchSdk(sdk:GiniSwitchSdk, didReview imageData:Data)
    func switchSdkDidComplete(sdk:GiniSwitchSdk)
    func switchSdk(sdk:GiniSwitchSdk, didExtractInfo info:ExtractionCollection)
    func switchSdk(sdk:GiniSwitchSdk, didReceiveError error:Error)
    func switchSdk(sdk:GiniSwitchSdk, didFailWithError error:Error)
    func switchSdkDidCancel(sdk:GiniSwitchSdk)

}
```

Out of those, as a minimum, the following need to be handled:

```swift
func switchSdkDidComplete(sdk:GiniSwitchSdk)
func switchSdk(sdk:GiniSwitchSdk, didFailWithError error:Error)
func switchSdkDidCancel(sdk:GiniSwitchSdk)
```

That's where the SDK will be done and it will need to be dismissed.

### Working with extractions

Naturally, the whole point in displaying the Gini Switch SDK is to get extractions. This is achieved via the

```swift
func switchSdk(sdk:GiniSwitchSdk, didExtractInfo info:ExtractionCollection)
```

method. It can be called multiple time throughout the lifecycle of the SDK - every time there's a change in the extractions. When our service determines that the extractions are complete, it will also call the `switchSdkDidComplete` delegate method. However, even before that, if the host app can determine that it has everything it needs, it is free to dismiss the SDK and continue on its own.

### Going back

While in the SDK's UI, users can exit prematurely by tapping on the "Done" button. They might do so too soon and therefore see that they need to go back and upload some more pictures. Unfortunately, this will happen after the `switchSdkDidComplete` delegate method call. So if you want to allow users to return to the SDK (And you should), make sure to hold on to the Switch SDK UI (the result from the `sdk.instantiateSwitchViewController()` statement) until you are sure users will not want to go back. After that, just clear the reference to the view controller and let ARC do the rest.