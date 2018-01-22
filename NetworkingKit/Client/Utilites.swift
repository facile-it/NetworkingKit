import Foundation

struct JSONString {
	static func from(_ object: Any) -> String {
		guard JSONSerialization.isValidJSONObject(object) else {
			return "Invalid JSON object"
		}
		guard let data = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) else {
			return "Error in creating data from valid JSON object"
		}
		guard let decoded = String(data: data, encoding: String.Encoding.utf8) else {
			return "Cannot create string from valid JSON data"
		}
		return decoded
			.replacingOccurrences(of: "\n", with: "")
			.replacingOccurrences(of: "\\/", with: "/")
	}
}
