import XCTest
@testable import PetriKitTests

XCTMain([
  testCase(PetriKitTests.allTests),
  testCase(PTNetTests.allTests),
  testCase(RandomTests.allTests),
])
