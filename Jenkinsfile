pipeline {
  agent none
  stages {
    stage('Build') {
      steps {
        sh 'travis_retry xcodebuild -workspace "$WORKSPACE" -scheme "$SCHEME" -sdk "$SDK" -destination "$DESTINATION" -configuration Debug GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES GCC_GENERATE_TEST_COVERAGE_FILES=YES test | xcpretty -c;'
      }
    }
  }
}