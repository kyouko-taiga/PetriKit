import XCTest
@testable import PetriKitTests

XCTMain([
  testCase(MarkingTests.allTests),
  testCase(PetriKitTests.allTests),
  testCase(PTNetTests.allTests),
  testCase(RandomTests.allTests),
])
