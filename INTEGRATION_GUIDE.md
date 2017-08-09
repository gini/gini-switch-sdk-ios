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
switchController = nil
sdk?.terminate()
sdk = nil
```

Just dismiss the view controller you got from the `sdk.instantiateSwitchViewController()`, terminate and discard the `GiniSwitchSdk` instance. ARC will take care of the rest.

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

### Sending Feedback

It is always possible that the extractions our services find in the document are not correct. We are continuously working on improving our algorithms and to achieve that we need you!

If you find an error in the extractions at a later stage in your app, you should send us "Feedback" - the correct values. This will help us train our extractors to better read documents.

In order to send feedback, there are several things to consider. After you get the extraction collection from your `GiniSwitchSdk` instance, just change the values of the particular field in the collection. With that new object, call the send feedback method:

```swift
sdk.sendFeedback(feedback)
```

After that, the SDK will send the updated fields to our backend. Upon completion the

```swift
func switchSdkDidSendFeedback(sdk:GiniSwitchSdk)
```

will be invoked. Please note that it will be called only if the feedback is successfully received by the backend. if not, the

```swift
func switchSdk(sdk:GiniSwitchSdk, didReceiveError error:Error)
```

will be called with an error type of `feedbackError`.

Another caveat to sending feedback is that you will have to keep the SDK "alive" until the request goes through. As already discussed in the "Going back" section, even after the SDK's UI is dismissed and the `switchSdkDidComplete` delegate method is invoked, the SDK still cannot be terminated and left to ARC to be cleared.

To properly dispose of the SDK after feedback is sent, wait until the `switchSdkDidSendFeedback` or the `didReceiveError` (with a `feedbackError` error type) to be invoked. Once that happens, terminate the SDK as described in "Dismiss the SDK".

## SDK Customizations

The Gini Switch SDK is designed to be an independent part of the hosting application. The overall UI and UX is fixed, but some parameters are customizable.

### UI changes

Regarding the looks of the SDK, the following values are changeable:

* `primaryColor` - The primary color is a color that will show up at many places throughout the SDK. It is used at times where an element branded with the main color of your app is appropriate. For instance, for Gini, it would be the blue color we use for our logo.
* `positiveColor` - The positive color is a color that will show up at many places throughout the SDK. It is used every time a component wants to indicate a success or a positive state in any way. For instance - a successful upload, analysis completion, correct extractions.
* `negativeColor` - The positive color is a color that will show up at many places throughout the SDK. It is used every time a component wants to indicate a failure or error state in any way. For instance - a failed upload, incorrect extractions.
* `screenBackgroundColor` - The background color most view controllers are going to use throughout the SDK.
* `pageAnalysisSuccessImage` - Image used for marking successfully analyzed images.
* `pageAnalysisFailureImage` - Image used for marking images that couldn't be analyzed.
* `doneButtonText` - Text for the Done button in the camera screen.
* `doneButtonTextColor` - Text color for the Done button in the camera screen.
* `imageProcessedText` - Text for the Preview screen - a successfully processed image.
* `imageProcessFailedText` - Text for the Preview screen - a failed processing of the image.
* `analyzedImage` - Image for the Analyzing Completed Screen.
* `analyzedText` - Text for the Analyzing Completed Screen.
* `analyzedTextColor` - Text color for the Analyzing Completed Screen.
* `analyzedTextSize` - Text size for the Analyzing Completed Screen.
* `exitActionSheetTitle` - Use this to set a custom title for the cancel dialog.

### Logging

Logging in the Switch SDK is achieved using the `GiniSwitchLogger` protocol. By default, the `GiniSwitchConsoleLogger` class is used. It just prints messages to the console. Feel free to implment the protocol and insert your own implementation. Change the default logger using the code:

```swift
sdk.configuration.logging = myCustomLogger
```
