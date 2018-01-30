import XCTest
@testable import NetworkingKit
import SwiftCheck
import Abstract

class PathTests: XCTestCase {
    func testPathError() {
        property("PathError's empty element is neutral") <- forAll { (ape: PathError) in
            Law.isNeutralToEmpty(ape)
        }
        
        property("PathError's composition operation must be associative") <- forAll { (ape1: PathError, ape2: PathError, ape3: PathError) in
            Law.isAssociative(ape1, ape2, ape3)
        }
        
        property("If two PathError are equal, their NSError must be as well") <- forAll { (ape1: PathError, ape2: PathError) in
            (ape1 == ape2) == (ape1.getNSError == ape2.getNSError)
        }
    }
    
    func testPath() {
        property("`get(path:)` always succeed from a Dictionary created from the passed `path`") <- forAll { (path: Path, val: Int) in
            guard let lastKey = path.keys.last else { return true }
            let dict = path.keys.reversed().reduce([String:Any]()){ current, key in
                key == lastKey
                    ? [key:val]
                    : [key:current]
            }
            let pathToInt = PathTo<Int>.init(root: dict)
            return pathToInt.get(path).fold(
                onSuccess: { _ in true },
                onFailure: { _ in false })
        }
    }
}
