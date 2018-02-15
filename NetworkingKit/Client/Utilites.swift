import Foundation
import FunctionalKit

struct JSONString {
	static func from(_ object: Any) -> JSONStringResult {
		guard JSONSerialization.isValidJSONObject(object) else {
			return .failure(.invalidJSONObject)
		}
		guard let data = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) else {
			return .failure(.dataCreationFailed)
		}
		guard let decoded = String(data: data, encoding: String.Encoding.utf8) else {
			return .failure(.stringCreationFailed)
		}
		return .success(decoded
			.replacingOccurrences(of: "\n", with: "")
			.replacingOccurrences(of: "\\/", with: "/"))
	}
}

enum JSONStringError: Error, CustomStringConvertible {
    case invalidJSONObject
    case dataCreationFailed
    case stringCreationFailed
    
    var description: String {
        switch self {
        case .invalidJSONObject:
            return "Invalid JSON object"
        case .dataCreationFailed:
            return "Error in creating data from valid JSON object"
        case .stringCreationFailed:
            return "Cannot create string from valid JSON data"
        }
    }
}

typealias JSONStringResult = Result<JSONStringError,String>

public func == <A,B> (lhs: [A : B]?, rhs: [A : B]?) -> Bool where B: Equatable {
	switch (lhs,rhs) {
	case (nil, nil):
		return true
	case (let left?, let right?):
		return left == right
	default:
		return false
	}
}
