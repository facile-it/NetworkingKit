import Abstract
import FunctionalKit

//sourcery: prism
public enum JSONError: Error, CustomStringConvertible {
    case serialization(NSError)
    case invalidTopLevelObject
    case nonJSONType
    
    public var description: String {
        switch self {
        case .serialization(let error):
            return error.localizedDescription
        case .invalidTopLevelObject:
            return "Invalid top level object"
        case .nonJSONType:
            return "Object is not a JSON type"
        }
    }
}

public typealias JSONResult<T> = Result<JSONError, T>

public protocol JSONNumber {
    var toNSNumber: NSNumber { get }
}

public enum JSONObject {
    case null
    case number(JSONNumber)
    case bool(Bool)
    case string(String)
    case array([JSONObject])
    case dict([String:JSONObject])
    
    public static func with(_ object: Any?) -> JSONResult<JSONObject> {
        guard let object = object else { return .success(.null) }
        
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
        case is JSONObjectConvertible:
            return .success((object as! JSONObjectConvertible).toJSONObject)
        default:
            return .failure(.nonJSONType)
        }
    }
    
    public static func optDict(key: String, value: Any?) -> JSONObject {
        return value
            .map(JSONObject.with)?
            .fold(onSuccess: { JSONObject.dict([key : $0]) },
                  onFailure: { _ in JSONObject.null })
            ?? .null
    }
    
    public var get: Any {
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
    
    public var getTopLevel: Any {
        switch self {
        case .null:
            return NSArray(array: [])
        case .number, .bool, .string:
            return NSArray(array: [get])
        case .array, .dict:
            return get
        }
    }
    
    public func isEqual(to other: JSONObject, numberPrecision: Double = 0.001) -> Bool {
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
    public static func == (left: JSONObject, right: JSONObject) -> Bool {
        return left.isEqual(to: right)
    }
}

extension JSONObject: Monoid {
    public static var empty: JSONObject {
        return .null
    }
    
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

public protocol JSONObjectConvertible {
    var toJSONObject: JSONObject { get }
}

extension JSONObjectConvertible {
    public func serializeJSONObject() -> JSONResult<Data> {
        return JSONSerialization.data(with: toJSONObject)
    }
}
