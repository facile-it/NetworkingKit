import XCTest
@testable import JSONObject
import SwiftCheck
import Abstract

class PathTests: XCTestCase {
    func testPathError() {
        property("PathError's composition operation must be associative") <- forAll { (ape1: PathError, ape2: PathError, ape3: PathError) in
            Law.isAssociative(ape1, ape2, ape3)
        }
    }
}
