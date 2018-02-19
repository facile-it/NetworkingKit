import Foundation

public protocol JSONObjectConvertible {
	var toJSONObject: JSONObject { get }
}

public extension JSONObjectConvertible {
	func serializeJSONObject() -> JSONResult<Data> {
		return JSONSerialization.data(with: toJSONObject)
	}
}

public extension JSONObject {
	static func with(_ object: JSONObjectConvertible) -> JSONResult<JSONObject> {
		return .success(object.toJSONObject)
	}
}
