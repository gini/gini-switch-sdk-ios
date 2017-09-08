pipeline {
  agent none
  stages {
    stage('Build') {
      steps {
        sh 'xcodebuild -workspace Example/GiniVision.xcworkspace/ -scheme GiniVision-Example | xcpretty'
      }
    }
  }
}