#
# Be sure to run `pod lib lint GiniSwitchSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GiniSwitchSDK'
  s.version          = '0.9.2'
  s.summary          = 'SDK for scanning and analysing german electricity bills'

  s.description      = <<-DESC
  The Gini Switch SDK provides components for capturing, reviewing and analyzing photos of electricity bills in Germany.
  By integrating this SDK into your application you can allow your users to easily take pictures of a document, review it and extract the necessary information to then proceed and change their electricity provider.
  The SDK takes care of all interactions with our backend and provides you with customizable UI you can easily integrate within your app to take care of the whole process for you.
  Even though some of the UI's appearance is customizable, the overall user flow and UX is not. We have worked hard to find the best way to navigate our users through the process and would like partners to follow the same path.
  The Gini Switch SDK has been designed for portrait orientation. The UI is automatically forced to portrait when being displayed.
                       DESC

  s.homepage         = 'https://github.com/gini/gini-switch-sdk-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Gini GmbH' => 'hello@gini.net' }
  s.source           = { :git => 'https://github.com/gini/gini-switch-sdk-ios.git', :tag => s.version.to_s }
   s.social_media_url = 'https://twitter.com/Gini'

  s.ios.deployment_target = '8.0'

  s.source_files = 'GiniSwitchSDK/GiniSwitchSDK/Classes/**/*'
  s.resources = 'GiniSwitchSDK/GiniSwitchSDK/Assets/*'

  # s.resource_bundles = {
  #   'GiniSwitchSDK' => ['GiniSwitchSDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
