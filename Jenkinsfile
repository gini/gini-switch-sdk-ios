pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'xcodebuild -workspace GiniSwitchSDK/Example/GiniSwitchSDK.xcworkspace -scheme "GiniSwitchSDK-Example" -destination \'platform=iOS Simulator,name=iPhone 6\''
      }
      steps {
        sh 'xcodebuild -workspace GiniSwitchSDK/Example/GiniSwitchSDK.xcworkspace -scheme "GiniSwitchSDK-Example" -destination \'platform=iOS Simulator,name=iPhone 6\' test'
      }
    }
  }
}
