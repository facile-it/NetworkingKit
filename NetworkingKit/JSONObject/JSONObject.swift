import Foundation
import Abstract
import FunctionalKit

public protocol JSONNumber {
    var toNSNumber: NSNumber { get }
}

// sourcery: prism
// sourcery: match
@available(*, deprecated, message: "Use Codable protocol instead")
public enum JSONObject {
    case null
    case number(JSONNumber)
    case bool(Bool)
    case string(String)
    case array([JSONObject])
    case dict([String:JSONObject])
}

// MARK: - Public

public extension JSONObject {
    @available(*, deprecated, message: "Use Codable protocol instead")
	static func with(_ object: Any) -> JSONResult<JSONObject> {
		switch object {
		case is NSNull:
			return .success(.null)
		case is Int:
			return .success(.number(object as! JSONNumber))
		case is UInt:
			return .success(.number(object as! JSONNumber))
		case is Float:
			return .success(.number(object as! JSONNumber))
		case is Double:
			return .success(.number(object as! JSONNumber))
		case is Bool:
			return .success(.bool(object as! Bool))
		case is String:
			return .success(.string(object as! String))
		case is [Any]:
			return (object as! [Any])
				.traverse(JSONObject.with)
				.map(JSONObject.array)
		case is [String:Any]:
			return (object as! [String:Any])
				.mapValues(JSONObject.with)
				.map { ($0,$1) }
				.traverse { (tuple) -> JSONResult<(String,JSONObject)> in
					let (key,result) = tuple
					return result.map{ (key,$0) } }
				.map { JSONObject.dict($0
					.reduce([:]) {
						var m_accumulation = $0
						m_accumulation[$1.0] = $1.1
						return m_accumulation})}
		default:
			return .failure(.nonJSONType)
		}
	}

    @available(*, deprecated, message: "Use Codable protocol instead")
	static func optDict(key: String, value: Any?) -> JSONObject {
		return value
			.map(JSONObject.with)?
			.fold(onSuccess: { JSONObject.dict([key : $0]) },
				  onFailure: f.pure(JSONObject.null))
			?? .null
	}

    @available(*, deprecated, message: "Use Codable protocol instead")
	var get: Any {
		switch self {
		case .null:
			return NSNull()
		case .number(let value):
			return value.toNSNumber
		case .bool(let value):
			return NSNumber(value: value)
		case .string(let value):
			return NSString(string: value)
		case .array(let array):
			return NSArray(array: array.map { $0.get })
		case .dict(let dictionary):
			return dictionary
				.map { ($0,$1.get) }
				.reduce(NSMutableDictionary()) {
					$0[$1.0] = $1.1
					return $0
				}
				.copy()
		}
	}

    @available(*, deprecated, message: "Use Codable protocol instead")
	var getTopLevel: Any {
		switch self {
		case .null:
			return NSArray(array: [])
		case .number, .bool, .string:
			return NSArray(array: [get])
		case .array, .dict:
			return get
		}
	}

    @available(*, deprecated, message: "Use Codable protocol instead")
	func isEqual(to other: JSONObject, numberPrecision: Double = 0.001) -> Bool {
		switch (self, other) {
		case (.null, .null):
			return true
		case (.number(let leftValue), .number(let rightValue)):
			return abs(leftValue.toNSNumber.doubleValue - rightValue.toNSNumber.doubleValue) <= numberPrecision
		case (.bool(let leftValue), .bool(let rightValue)):
			return leftValue == rightValue
		case (.string(let leftValue), .string(let rightValue)):
			return leftValue == rightValue
		case (.array(let objects1),.array(let objects2)):
			return objects1.isEqual(to: objects2) { $0.isEqual(to: $1, numberPrecision: numberPrecision) }
		case (.dict(let objects1),.dict(let objects2)):
			return objects1.isEqual(to: objects2) { $0.isEqual(to: $1, numberPrecision: numberPrecision) }
		default:
			return false
		}
	}
}

extension JSONObject: Equatable {
    @available(*, deprecated, message: "Use Codable protocol instead")
    public static func == (left: JSONObject, right: JSONObject) -> Bool {
        return left.isEqual(to: right)
    }
}

extension JSONObject: Monoid {
    @available(*, deprecated, message: "Use Codable protocol instead")
    public static var empty: JSONObject {
        return .null
    }
    
    @available(*, deprecated, message: "Use Codable protocol instead")
    public static func <> (_ left: JSONObject, _ right: JSONObject) -> JSONObject {
        switch (left,right) {
        case (.null,_):
            return right
        case (_,.null):
            return left
        case (.array(let objects1),.array(let objects2)):
            return .array(objects1 + objects2)
        case (.dict(let objects1),.dict(let objects2)):
            return .dict(objects1.merging(objects2, uniquingKeysWith: f.second))
        case (.dict,_):
            return left
        case (_,.dict):
            return right
        case (.array(let objects),_):
            return .array(objects + [right])
        case (_,.array(let objects)):
            return .array([left] + objects)
        default:
            return .array([left,right])
        }
    }
}
