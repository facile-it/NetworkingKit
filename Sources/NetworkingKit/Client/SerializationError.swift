import Foundation

// sourcery: prism
// sourcery: match
@available(*, deprecated, message: "Use Codable protocol instead")
public enum SerializationError: Equatable {
	case toJSON
	case toFormURLEncoded

	public static let errorDomain = "Serialization"
}

// sourcery: prism
// sourcery: match
@available(*, deprecated, message: "Use Codable protocol instead")
public enum DeserializationError: Equatable {
	case toAny(NSError?)
	case toAnyDict(NSError?)
	case toArray(NSError?)
	case toString

	public static let errorDomain = "Deserialization"
}

// MARK: - Public

public extension SerializationError {
    
    @available(*, deprecated, message: "Use Codable protocol instead")
	var getNSError: NSError {
		switch self {
		case .toJSON:
			return NSError(
				domain: SerializationError.errorDomain,
				code: 0,
				userInfo: [NSLocalizedDescriptionKey :  "Cannot serialize into JSON"])
		case .toFormURLEncoded:
			return NSError(
				domain: SerializationError.errorDomain,
				code: 0,
				userInfo: [NSLocalizedDescriptionKey :  "Cannot serialize into form-url-encoded"])
		}
	}
}

extension SerializationError: CustomStringConvertible {
    
    @available(*, deprecated, message: "Use Codable protocol instead")
	public var description: String {
		switch self {
		case .toJSON:
			return "SerializationError: JSON"
		case .toFormURLEncoded:
			return "SerializationError: form-url-encoded"
		}
	}
}

public extension DeserializationError {
    
    @available(*, deprecated, message: "Use Codable protocol instead")
    var getNSError: NSError {
		switch self {
		case .toAny(let optionalError):
			return optionalError ?? NSError(
				domain: DeserializationError.errorDomain,
				code: 0,
				userInfo: [NSLocalizedDescriptionKey : "Cannot deserialize into 'Any'"])
		case .toAnyDict(let optionalError):
			return optionalError ?? NSError(
				domain: DeserializationError.errorDomain,
				code: 1,
				userInfo: [NSLocalizedDescriptionKey : "Cannot deserialize into '[String:Any]'"])
		case .toArray(let optionalError):
			return optionalError ?? NSError(
				domain: DeserializationError.errorDomain,
				code: 2,
				userInfo: [NSLocalizedDescriptionKey : "Cannot deserialize into 'Array'"])
		case .toString:
			return NSError(
				domain: DeserializationError.errorDomain,
				code: 3,
				userInfo: [NSLocalizedDescriptionKey : "Cannot deserialize into 'String'"])
		}
	}
}

extension DeserializationError: CustomStringConvertible {
    
    @available(*, deprecated, message: "Use Codable protocol instead")
	public var description: String {
		switch self {
		case .toAny:
			return "DeserializationError: toAny"
		case .toAnyDict:
			return "DeserializationError: to[String:Any]"
		case .toArray:
			return "DeserializationError: toArray"
		case .toString:
			return "DeserializationError: toString"
		}
	}
}
