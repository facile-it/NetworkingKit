import Foundation

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

extension Int: JSONNumber {
    @available(*, deprecated, message: "Use Codable protocol instead")
    public var toNSNumber: NSNumber {
        return NSNumber(value: self)
    }
}

extension UInt: JSONNumber {
    @available(*, deprecated, message: "Use Codable protocol instead")
    public var toNSNumber: NSNumber {
        return NSNumber(value: self)
    }
}

extension Float: JSONNumber {
    @available(*, deprecated, message: "Use Codable protocol instead")
    public var toNSNumber: NSNumber {
        return NSNumber(value: self)
    }
}

extension Double: JSONNumber {
    @available(*, deprecated, message: "Use Codable protocol instead")
    public var toNSNumber: NSNumber {
        return NSNumber(value: self)
    }
}

extension NSNumber: JSONNumber {
    @available(*, deprecated, message: "Use Codable protocol instead")
    public var toNSNumber: NSNumber {
        return self
    }
}

extension JSONSerialization {
    @available(*, deprecated, message: "Use Codable protocol instead")
    public static func data(with object: JSONObject) -> JSONResult<Data> {
        let topLevelObject = object.getTopLevel
        guard JSONSerialization.isValidJSONObject(topLevelObject) else {
            return .failure(.invalidTopLevelObject)
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: topLevelObject)
            return .success(data)
        }
        catch let error as NSError{
            return .failure(.serialization(error))
        }
    }
}

