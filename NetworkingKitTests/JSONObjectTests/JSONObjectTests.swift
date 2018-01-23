import XCTest
import SwiftCheck
@testable import NetworkingKit
import Abstract

class JSONObjectSpec: XCTestCase {

	func testCreationWithOptional() {
		property("JSONObject creation with Optional will result in .null if Optional is .none, or other if .some - 1") <- {
			let some: Int? = 42
			let none: Int? = nil

			return (JSONObject.with(some).fold(
                onSuccess: { $0.isNull.not },
                onFailure: { _ in false })) <?> "With .some"
				^&&^
				(JSONObject.with(none).fold(
                    onSuccess: { $0.isNull },
                    onFailure: { _ in false })) <?> "With .none"
		}

		property("JSONObject creation with Optional will result in .null if Optional is .none, or other if .some - 2") <- forAll { (opt: OptionalOf<Int>) in
			let optional = opt.getOptional
			return JSONObject.with(optional).fold(
                onSuccess: { $0.isNull == (optional == nil) },
                onFailure: { _ in false })
		}
	}

	func testCreationIsConsistentWithPassedType() {
		property("JSONObject creation with NSNull will result in .null") <- {
			return JSONObject.with(NSNull()).fold(
                onSuccess: { $0.isNull },
                onFailure: { _ in false })
		}

		property("JSONObject creation with Bool will result in .bool") <- {
			return (JSONObject.with(true).fold(
                onSuccess: { $0.isBool(true) },
                onFailure: { _ in false })) <?> "With true"
				^&&^
				(JSONObject.with(false).fold(
                    onSuccess: { $0.isBool(false) },
                    onFailure: { _ in false })) <?> "With false"
		}

		property("JSONObject creation with Int, UInt, Float, Double will result in .number") <- forAll { (ajn: ArbitraryJSONNumber) in
			let jn = ajn.get
			return JSONObject.with(jn).fold(
                onSuccess: { $0.isNumber(jn) },
                onFailure: { _ in false })
		}

		property("JSONObject creation with NSNumber will result in .number") <- forAll { (ajn: ArbitraryJSONNumber) in
			let number = ajn.get.toNSNumber
			return JSONObject.with(number).fold(
                onSuccess: { $0.isNumber(number) },
                onFailure: { _ in false })
		}

		property("JSONObject creation with String will result in .string") <- forAll { (string: String) in
			return JSONObject.with(string).fold(
                onSuccess: { $0.isString(string) },
                onFailure: { _ in false })
		}

		property("JSONObject creation with Array will result in .array") <- forAll { (arrayOf: ArrayOf<TrueArbitrary>) in
			let array = arrayOf.getArray
			return JSONObject.with(array).fold(
                onSuccess: { $0.isArray(array) },
                onFailure: { _ in false })
		}

		property("JSONObject creation with Dictionary will result in .dict") <- forAll { (dictOf: DictionaryOf<String,TrueArbitrary>) in
			let dict: [String:Any] = dictOf.getDictionary
			return JSONObject.with(dict).fold(
                onSuccess: { $0.isDict(dict) },
                onFailure: { _ in false })
		}
	}

	func testGetIsConsistentWithJSONObjectTypeAndContainedValue() {
		property("JSONObject.get is consistent .null") <- {
			NSNull().isEqual(JSONObject.null.get)
		}

		property("JSONObject.get is consistent with bool") <- {
			let isBoolTrue = NSNumber(value: true).isEqual(JSONObject.bool(true).get)
			let isBoolFalse = NSNumber(value: false).isEqual(JSONObject.bool(false).get)
			return isBoolTrue <?> "Is consistent for true"
				^&&^
				isBoolFalse <?> "Is consistent for false"
		}

		property("JSONObject.get is consistent number") <- forAll { (ajn: ArbitraryJSONNumber) in
			let number = ajn.get
			return number.toNSNumber.isEqual(JSONObject.number(number).get)
		}

		property("JSONObject.get is consistent with string") <- {
			return NSString(string: "ciao").isEqual(JSONObject.string("ciao").get)
		}

		property("JSONObject.get is consistent with array") <- {
			return NSArray(array: [1,
			                       "2",
			                       true])
				.isEqual(JSONObject.array([.number(1),
				                           .string("2"),
				                           .bool(true)]).get)
		}

		property("JSONObject.get is consistent with dictionary") <- {

			return NSDictionary(dictionary: ["1":1,
			                                 "2":"2",
			                                 "3":true])
				.isEqual(JSONObject.dict(["1":.number(1),
				                          "2":.string("2"),
				                          "3":.bool(true)]).get)
		}
	}

	func testProcessingConsistencyBetweenWithAndGet() {
		property("JSONObject processing consistency: null") <- {
			return NSNull().isEqual(JSONObject.with(NSNull()).fold(
                onSuccess: { $0.get },
                onFailure: { _ in false }))
		}

		property("JSONObject processing consistency: bool") <- {
            return NSNumber(value: true).isEqual(JSONObject.with(true).fold(
                onSuccess: { $0.get },
                onFailure: { _ in false }))
                && NSNumber(value: false).isEqual(JSONObject.with(false).fold(
                    onSuccess: { $0.get },
                    onFailure: { _ in false }))
		}

		property("JSONObject processing consistency: number") <- forAll { (ajn: ArbitraryJSONNumber) in
            return ajn.get.toNSNumber.isEqual(JSONObject.with(ajn.get).fold(
                onSuccess: { $0.get },
                onFailure: { _ in false }))
		}

		property("JSONObject processing consistency: string") <- forAll { (string: String) in
            return NSString(string: string).isEqual(JSONObject.with(string).fold(
                onSuccess: { $0.get },
                onFailure: { _ in false }))
		}

		property("JSONObject processing consistency: array") <- {
			let array = NSArray(array: [1,"2",true])
            return array.isEqual(JSONObject.with(array).fold(
                onSuccess: { $0.get },
                onFailure: { _ in false }))
		}

		property("JSONObject processing consistency: dictionary") <- {
			let dict = NSDictionary(dictionary: ["1":1,"2":"2","3":true])
            return dict.isEqual(JSONObject.with(dict).fold(
                onSuccess: { $0.get },
                onFailure: { _ in false }))
		}
	}

	func testDataGenerationProducesNoErrors() {
		property("no error for data with null") <- {
			return JSONSerialization.data(with: .null).fold(
                    onSuccess: { _ in true },
                    onFailure: { _ in false })
		}

		property("no error for data with number") <- forAll { (ajn: ArbitraryJSONNumber) in
			JSONSerialization.data(with: .number(ajn.get)).fold(
                    onSuccess: { _ in true },
                    onFailure: { _ in false })
		}

        property("no error for data with bool") <- forAll { (bool: Bool) in
			JSONSerialization.data(with: .bool(bool)).fold(
                onSuccess: { _ in true},
                onFailure: { _ in false })
		}

		property("no error for data with string") <- forAll { (string: String) in
			JSONSerialization.data(with: .string(string)).fold(
                onSuccess: { _ in true },
                onFailure: { _ in false })
		}

		property("no error for data with array") <- {
			JSONSerialization.data(with: .array([.number(1),.string("2"),.bool(true)])).fold(
                onSuccess: { _ in true },
                onFailure: { _ in false })
		}

		property("no error for data with dictionary") <- {
			JSONSerialization.data(with: .dict(["1":.number(1),"2":.string("2"),"3":.bool(true)])).fold(
                onSuccess: { _ in true },
                onFailure: { _ in false })
		}
	}

	func testOptDict() {
		property(".optDict generates a valid .dict JSONObject (with no .null value) or .null") <- forAll { (ao: OptionalOf<TrueArbitrary>, key: String) in
			let optional = ao.getOptional?.get
			let generated = JSONObject.optDict(key: key, value: optional)
            
			if optional == nil {
				return generated == .null
            } else if optional! is Int {
                return generated == .dict([key : .number(optional as! Int)])
            } else if optional! is Someclass {
                return generated == .dict([key : .string((optional as! Someclass).value)])
            } else if optional! is Somestruct {
                return generated == .dict([key : .string((optional as! Somestruct).value)])
			} else {
				return generated == .null
			}
		}
	}

	func testEquality() {
		property("arbitrary JSONObject is equal to itself") <- forAll { (object: JSONObject) in
			object == object
		}

		property(".null equality is respected") <- {
			JSONObject.null == JSONObject.null
		}

		property(".number equality is respected") <- forAll { (ajn: ArbitraryJSONNumber) in
			JSONObject.number(ajn.get) == JSONObject.number(ajn.get)
		}

		property(".bool equality is respected") <- {
			return (JSONObject.bool(true) == JSONObject.bool(true)) <?> "Is respected for true"
				^&&^
				(JSONObject.bool(false) == JSONObject.bool(false)) <?> "Is respected for false"
				^&&^
				(JSONObject.bool(true) != JSONObject.bool(false)) <?> "Is respected for opposites"
		}

		property(".string equality is respected") <- forAll { (string: String) in
			JSONObject.string(string) == JSONObject.string(string)
		}

		property(".array equality is respected") <- forAll { (arrayOf: ArrayOf<JSONObject>) in
			JSONObject.array(arrayOf.getArray) == JSONObject.array(arrayOf.getArray)
		}

		property(".dict equality is respected") <- forAll { (dictionaryOf: DictionaryOf<String,JSONObject>) in
			JSONObject.dict(dictionaryOf.getDictionary) == JSONObject.dict(dictionaryOf.getDictionary)
		}
	}

	func testMonoidLaws() {
		property("1•a = a•1 = a ") <- forAll { (object: JSONObject) in
            Law.isNeutralToEmpty(object)
		}

		property("(a•b)•c = a•(b•c)") <- forAll { (object1: JSONObject, object2: JSONObject, object3: JSONObject) in
            Law.isAssociative(object1, object2, object3)
		}
	}
}
