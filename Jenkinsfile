pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'xcodebuild -workspace GiniSwitchSDK/Example/GiniSwitchSDK.xcworkspace -scheme "GiniSwitchSDK-Example" -destination \'platform=iOS Simulator,name=iPhone 6\''
      }
    }
    stage('Test') {
      steps {
        sh 'xcodebuild -workspace GiniSwitchSDK/Example/GiniSwitchSDK.xcworkspace -scheme "GiniSwitchSDK-Example" -destination \'platform=iOS Simulator,name=iPhone 6\' test'
      }
    }
    stage('Hockey deployment') {
      when {
        branch 'feature-inject-creds'
      }
      environment {
         HOCKEYAPP_ID = credentials('SwitchIOSHockeyAppID')
         HOCKEYAPP_API_KEY = credentials('SwitchHockeyappAPIKey')
         CLIENT_ID = credentials('SwitchSdkClientId')
         CLIENT_PASSWORD = credentials('SwitchSdkClientSecret')
      }
      steps {
        sh 'rm -rf build'
        sh 'mkdir build'
        sh 'scripts/generateCredentialsFile.sh ${CLIENT_ID} ${CLIENT_PASSWORD} gini.net GiniSwitchSDK/Example/GiniTariffSDK/Credentials.plist'
        sh 'scripts/buildNumberIncrement.sh GiniSwitchSDK/Example/GiniTariffSDK/Info.plist ${BUILD_NUMBER}'
        sh 'xcodebuild -workspace GiniSwitchSDK/Example/GiniSwitchSDK.xcworkspace -scheme GiniSwitchSDK-Example -configuration Release archive -archivePath build/GiniSwitchSDKExample.xcarchive -allowProvisioningUpdates'
        sh 'xcodebuild -exportArchive -archivePath build/GiniSwitchSDKExample.xcarchive -exportOptionsPlist scripts/exportOptionsEnterprise.plist -exportPath build -allowProvisioningUpdates'
        step([$class: 'HockeyappRecorder', applications: [[apiToken: env.HOCKEYAPP_API_KEY, downloadAllowed: true, filePath: 'build/GiniSwitchSDK-Example.ipa', mandatory: false, notifyTeam: false, releaseNotesMethod: [$class: 'NoReleaseNotes'], uploadMethod: [$class: 'VersionCreation', appId: env.HOCKEYAPP_ID]]], debugMode: false, failGracefully: false])

      }
      post {
        always {
          sh 'rm -rf build'
          sh 'rm GiniSwitchSDK/Example/GiniTariffSDK/Credentials.plist || true'
        }
      }
    }
  }
}
