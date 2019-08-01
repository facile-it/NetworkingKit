import XCTest
import SwiftCheck
import NetworkingKit
import Abstract
import FunctionalKit

class SerializeTests: XCTestCase {
    
	func testJSON() {
		property("'toJSON' is invertible for dict", arguments: .with(25072100,913394349,10)) <- forAll { (ao: Dictionary<String,String>) in
			let object = ao
			let data = Serialize.toJSON(object).toOptionalValue()!
			let gotObject = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,String>
			return gotObject == object
		}

		property("'toJSON' is invertible for array") <- forAll { (ao: Array<String>) in
			let object = ao
			let data = Serialize.toJSON(object).toOptionalValue()!
			let gotObject = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Array<String>
			return gotObject == object
		}

		
		property("'fromJSONObject' is invertible") <- forAll { (ao: JSONObject) in
            do {
                let object = try JSONObject.with(ao.getTopLevel).get()
                let data = Serialize.fromJSONObject(object).toOptionalValue()!
                let gotObject = (try! JSONSerialization.jsonObject(with: data, options: .allowFragments)) |> JSONObject.with
                return gotObject.fold(
                    onSuccess: { $0.isEqual(to: object, numberPrecision: 0.1) },
                    onFailure: f.pure(false))
            }
            catch {
                return false
            }
		}
	}
}
