import Foundation
import Abstract


public enum Serialize {

    @available(*, deprecated, message: "Use Codable protocol instead")
	public static func toJSON(_ object: Any) -> ClientResult<Data> {
		return JSONObject.with(object)
			.flatMap(JSONSerialization.data)
			.mapError { _ in ClientError.serialization(.toJSON) }
	}

    @available(*, deprecated, message: "Use Codable protocol instead")
	public static func fromJSONObject(_ object: JSONObject) -> ClientResult<Data> {
		return JSONSerialization.data(with: object)
			.mapError { _ in ClientError.serialization(.toJSON) }
	}

	public static func toFormURLEncoded(_ dict: [String:Any]) -> ClientResult<Data> {
		if let data = wsBodyDataURLEncodedString(dict: dict, rootKey: nil).data(using: String.Encoding.utf8) {
			return .success(data)
		} else {
			return .failure(ClientError.serialization(.toFormURLEncoded))
		}
	}
}

private extension Serialize {
	typealias PlistStringReducer = (String, (String, Any)) -> String

	static func wsBodyDataURLEncodedString(dict: [String:Any], rootKey: String?) -> String {
		var characters = dict.reduce("", wsBodyDataURLEncodedReducerWithRootKey(rootKey))
		characters.removeFirst()
		return characters
	}

	static func wsBodyDataURLEncodedReducerWithRootKey(_ rootKey: String?) -> PlistStringReducer {
		return {
			let accumulation = $0
			let key = $1.0
			let value = $1.1
			let stringKey = rootKey.map { "\($0)[\(key)]" } ?? key
			let newString: String
			switch value {
			case let subPlist as [String:Any]:
				newString = wsBodyDataURLEncodedString(dict: subPlist, rootKey: key)
			default:
				newString = "\(stringKey)=\(value)"
			}
			return accumulation + "&" + newString
		}
	}
}

public enum Deserialize {
    
	public static func ignored(_ _: Data) -> ClientResult<()> {
		return .success(())
	}

	public static func toAnyJSON(_ data: Data) -> ClientResult<Any> {
		do {
			return try .success(JSONSerialization.jsonObject(with: data, options: .allowFragments))
		}
		catch let error as NSError {
			return .failure(ClientError.deserialization(.toAny(error)))
		}
	}

	public static func toAnyDictJSON(_ data: Data) -> ClientResult<[String:Any]> {
		do {
			if let plist = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] {
				return .success(plist)
			} else {
				return .failure(ClientError.deserialization(.toAnyDict(nil)))
			}
		}
		catch let error as NSError {
			return .failure(ClientError.deserialization(.toAnyDict(error)))
		}
	}
    
	public static func toAnyArrayJSON(_ data: Data) -> ClientResult<[Any]> {
		do {
			if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any] {
				return .success(array)
			} else {
				return .failure(ClientError.deserialization(.toArray(nil)))
			}
		}
		catch let error as NSError {
			return .failure(ClientError.deserialization(.toArray(error)))
		}
	}

	public static func toAnyDictArrayJSON(_ data: Data) -> ClientResult<[[String:Any]]> {
		do {
			if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:Any]] {
				return .success(array)
			} else {
				return .failure(ClientError.deserialization(.toArray(nil)))
			}
		}
		catch let error as NSError {
			return .failure(ClientError.deserialization(.toArray(error)))
		}
	}

	public static func toString(_ data: Data) -> ClientResult<String> {
		if let string = String(data: data, encoding: String.Encoding.utf8) {
			return .success(string)
		} else {
			return .failure(ClientError.deserialization(.toString))
		}
	}
}
