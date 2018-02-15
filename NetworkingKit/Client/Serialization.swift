import Foundation
import Abstract

// MARK: Serialize

public struct Serialize {
	public static var toJSON: (Any) -> ClientResult<Data> {
		return { object in
            return JSONObject.with(object)
                .flatMap(JSONSerialization.data)
                .mapError { _ in ClientError.serialization(.toJSON) }
		}
	}

	public static var fromJSONObject: (JSONObject) -> ClientResult<Data> {
		return { object in
            return JSONSerialization.data(with: object)
                .mapError { _ in ClientError.serialization(.toJSON) }
		}
	}

	public static var toFormURLEncoded: ([String:Any]) -> ClientResult<Data> {
		return { dict in
			if let data = wsBodyDataURLEncodedString(dict: dict, rootKey: nil).data(using: String.Encoding.utf8) {
				return .success(data)
			} else {
				return .failure(ClientError.serialization(.toFormURLEncoded))
			}
		}
	}

	fileprivate typealias PlistStringReducer = (String, (String, Any)) -> String

	fileprivate static func wsBodyDataURLEncodedString(dict: [String:Any], rootKey: String?) -> String {
		var characters = dict.reduce("", wsBodyDataURLEncodedReducerWithRootKey(rootKey))
		characters.removeFirst()
		return characters
	}

	fileprivate static func wsBodyDataURLEncodedReducerWithRootKey(_ rootKey: String?) -> PlistStringReducer {
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

// MARK: Deserialize

public struct Deserialize {
	public static var ignored: (Data) -> ClientResult<()> { return { _ in .success(()) } }

	public static var toAnyJSON: (Data) -> ClientResult<Any> {
		return { data in
			do {
				return try .success(JSONSerialization.jsonObject(with: data, options: .allowFragments))
			}
			catch let error as NSError {
				return .failure(ClientError.deserialization(.toAny(error)))
			}
		}
	}

	public static var toAnyDictJSON: (Data) -> ClientResult<[String:Any]> {
		return { data in
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
	}

	public static var toAnyArrayJSON: (Data) -> ClientResult<[Any]> {
		return { data in
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
	}

	public static var toAnyDictArrayJSON: (Data) -> ClientResult<[[String:Any]]> {
		return { data in
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
	}

	public static var toString: (Data) -> ClientResult<String> {
		return { data in
			if let string = String(data: data, encoding: String.Encoding.utf8) {
				return .success(string)
			} else {
				return .failure(ClientError.deserialization(.toString))
			}
		}
	}
}
