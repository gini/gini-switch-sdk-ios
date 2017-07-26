![Gini Vision Library for iOS](https://www.gini.net/assets/GiniVision_Logo.png)

# Gini Switch SDK for iOS

TODO: CI status

The Gini Switch SDK provides components for capturing, reviewing and analyzing photos of electricity bills in Germany.

By integrating this SDK into your application you can allow your users to easily take a picture of a document, review it and extract the necessary information to then proceed and change their electricity provider.

The SDK takes care of all interactions with our backend and provides you with customizable UI you can easily integrate within your app to take care of the whole process for you.

Even though a lot of the UI's appearance is customizable, the overall user flow and UX is not. We have worked hard to find the best way to navigate our users through the process and would like partners to follow the same path.

The Gini Switch SDK has been designed for portrait orientation. The UI is automatically forced to portrait when being displayed.

## Documentation

Further documentation can be found in our INTEGRATION_GUIDE.

TODO: Add links to documentation

## Architecture

The Gini Switch SDK consists of four main components

* Onboarding: Provides useful hints to the users how to take a perfect photo of a document,
* Camera: The actual camera screen to capture the image of the document,
* Review: Offers the opportunity to the user to check the sharpness of the image and eventually to rotate it into reading direction,
* Document bar: A collection view on the top of the screen, where people can see what pictures they've taken and their status

Since the Gini Switch SDK is designed to autonomously guide users through the whole process, it is really easy for you to integrate. Just initialize it with your client ID, secret and domain, obtain a reference to our initial view controller and present it to the user.

More specifics about the integration process can be found in INTEGRATION_GUIDE

## Example

## Requirements

- iOS 9.0+    TODO: Is this correct?
- Xcode 8.0+

## Installation

Gini Switch SDK can either be installed by using CocoaPods or by manually dragging the required files to your project.

**Note**: Irrespective of the option you choose if you want to support **iOS 10** you need to specify the `NSCameraUsageDescription` key in your `Info.plist` file. This key is mandatory for all apps since iOS 10 when using the `Camera` framework. Also you need to add support for "Keychain Sharing" in your entitlements by adding a `keychain-access-groups` value to your entitlements file.

### Swift versions

The Gini Switch SDK is entirely written in **Swift 3**.

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build Gini Switch SDK.


To integrate Gini Switch SDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

TODO: sample code?

**Note:** You need to add Gini's podspec repository as a source.
TODO: still so?

Then run the following command:

```bash
$ pod install
```

### Manually

If you prefer not to use a dependency management tool, you can integrate the Gini Vision SDK into your project manually.
To do so drop the GiniSwitchSDK (classes and assets) folder into your project and add the files to your target.

Xcode will automatically check your project for swift files and will create an autogenerated import header for you.
Use this header in an Objective-C project by adding

```Obj-C
#import "YourProjectName-Swift.h"
```

to your implementation or header files. Note that spaces in your project name result in underscores. So `Your Project` becomes `Your_Project-Swift.h`.

## Branches

## License

The Gini Switch SDK for iOS is licensed under the MIT License. See the LICENSE file for more info.

**Important:** Always make sure to ship all license notices and permissions with your application.
