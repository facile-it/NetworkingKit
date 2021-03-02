import Foundation

@available(*, deprecated, message: "Use Codable protocol instead")
public protocol JSONObjectConvertible {
	var toJSONObject: JSONObject { get }
}

public extension JSONObjectConvertible {
    @available(*, deprecated, message: "Use Codable protocol instead")
	func serializeJSONObject() -> JSONResult<Data> {
		return JSONSerialization.data(with: toJSONObject)
	}
}

public extension JSONObject {
    @available(*, deprecated, message: "Use Codable protocol instead")
	static func with(_ object: JSONObjectConvertible) -> JSONResult<JSONObject> {
		return .success(object.toJSONObject)
	}
}
