import Foundation

// sourcery: prism
// sourcery: match
// sourcery: equatable
@available(*, deprecated, message: "Use Codable protocol instead")
public enum JSONError: Error {
	case serialization(NSError)
	case invalidTopLevelObject
	case nonJSONType
}

// MARK: - Public

extension JSONError: CustomStringConvertible {
    @available(*, deprecated, message: "Use Codable protocol instead")
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

@available(*, deprecated, message: "Use Codable protocol instead")
public typealias JSONResult<T> = Result<T, JSONError>
