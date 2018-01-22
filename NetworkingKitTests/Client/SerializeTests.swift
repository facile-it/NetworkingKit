import XCTest
import SwiftCheck
import NetworkingKit
import Abstract
import FunctionalKit

class SerializeTests: XCTestCase {
    
	func testJSON() {
		property("'toJSON' is invertible for dict") <- forAll { (ao: DictionaryOf<String,String>) in
			let object = ao.getDictionary
			let data = Serialize.toJSON(object).toOptionalValue!
			let gotObject = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,String>
			return gotObject == object
		}

		property("'toJSON' is invertible for array") <- forAll { (ao: ArrayOf<String>) in
			let object = ao.getArray
			let data = Serialize.toJSON(object).toOptionalValue!
			let gotObject = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Array<String>
			return gotObject == object
		}

		
		property("'fromJSONObject' is invertible") <- forAll { (ao: JSONObject) in
			let object = JSONObject.with(ao.getTopLevel)
			let data = Serialize.fromJSONObject(object).toOptionalValue!
			let gotObject = (try! JSONSerialization.jsonObject(with: data, options: .allowFragments)) |> JSONObject.with
			return gotObject.isEqual(to: object, numberPrecision: 0.1)
		}
	}
}
