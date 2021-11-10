import Foundation

// sourcery: prism
// sourcery: match
public enum JSONError: Error, Equatable {
	case serialization(NSError)
	case invalidTopLevelObject
	case nonJSONType
}

// MARK: - Public

extension JSONError: CustomStringConvertible {
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

public typealias JSONResult<T> = Result<T, JSONError>
