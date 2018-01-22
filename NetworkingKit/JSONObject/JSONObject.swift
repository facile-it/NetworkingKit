import Abstract
import FunctionalKit

extension Array {
    func isEqual(to other: [Element], considering predicate: (Element,Element) -> Bool) -> Bool {
        guard count == other.count else { return false }
        for (index,element) in enumerated() {
            if predicate(element,other[index]) == false {
                return false
            }
        }
        return true
    }
}

extension Dictionary {
    func isEqual(to other: [Key:Value], considering predicate: (Value,Value) -> Bool) -> Bool {
        guard self.count == other.count else { return false }
        for key in keys {
            let selfValue = self[key]
            let otherValue = other[key]
            switch (selfValue,otherValue) {
            case (.some,.none):
                return false
            case (.none,.some):
                return false
            case let (.some(failure),.some(success)):
                if predicate(failure,success) == false {
                    return false
                }
            default:
                break
            }
        }
        return true
    }
}

public protocol JSONNumber {
    var toNSNumber: NSNumber { get }
}

extension Int: JSONNumber {
    public var toNSNumber: NSNumber {
        return NSNumber(value: self)
    }
}

extension UInt: JSONNumber {
    public var toNSNumber: NSNumber {
        return NSNumber(value: self)
    }
}

extension Float: JSONNumber {
    public var toNSNumber: NSNumber {
        return NSNumber(value: self)
    }
}

extension Double: JSONNumber {
    public var toNSNumber: NSNumber {
        return NSNumber(value: self)
    }
}

extension NSNumber: JSONNumber {
    public var toNSNumber: NSNumber {
        return self
    }
}

public enum JSONObject {
    case null
    case number(JSONNumber)
    case bool(Bool)
    case string(String)
    case array([JSONObject])
    case dict([String:JSONObject])
    
    public static func with(_ object: Any?) -> JSONObject {
        
        guard let object = object else { return .null }
        
        switch object {
        case is NSNull:
            return .null
        case is Int:
            return .number(object as! JSONNumber)
        case is UInt:
            return .number(object as! JSONNumber)
        case is Float:
            return .number(object as! JSONNumber)
        case is Double:
            return .number(object as! JSONNumber)
        case is Bool:
            return .bool(object as! Bool)
        case is String:
            return .string(object as! String)
        case is [Any]:
            return .array((object as! [Any]).map(JSONObject.with))
        case is [String:Any]:
            return .dict((object as! [String:Any])
                .map { ($0,JSONObject.with($1)) }
                .reduce([:]) {
                    var m_accumulation = $0
                    m_accumulation[$1.0] = $1.1
                    return m_accumulation
            })
        default:
            return .null
        }
    }
    
    public static func optDict(key: String, value: Any?) -> JSONObject {
        return value
            .map { .with($0) }
            .flatMap { $0 != .null ? $0 : nil }
            .map { .dict([key : $0]) }
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

extension JSONSerialization {
    public static func data(with object: JSONObject) throws -> Data {
        let topLevelObject = object.getTopLevel
        guard JSONSerialization.isValidJSONObject(topLevelObject) else {
            throw NSError(
                domain: "JSONSerialization",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey : "Invalid JSON object",
                           "OriginalJSONObject" : object,
                           "GotTopLevelObject" : topLevelObject])
        }
        return try JSONSerialization.data(withJSONObject: topLevelObject)
    }
}

