import Foundation
import FunctionalKit
import Abstract

public enum Parse {

	public enum Response {

		public static func acceptOnly(httpCodes accepted: [Int], parseErrorsWith errorStrategy: @escaping ([String:Any]) -> ClientResult<[String:Any]> = { .success($0) }) -> (HTTPResponse<Data>) -> ClientResult<HTTPResponse<Data>> {
			return { response in
				let code = response.URLResponse.statusCode
				guard accepted.contains(code) else {
					return ClientResult.pure(response.output)
						.flatMap(Deserialize.toAnyDictJSON)
						.mapError { _ in .invalidHTTPCode(code) }
						.flatMap(errorStrategy)
						.flatMap { _ in ClientResult<HTTPResponse<Data>>.failure(.invalidHTTPCode(code)) }
				}
				return .success(response)
			}
		}

		public static func checkUnauthorized(withHTTPCodes codes: [Int] = [401]) -> (HTTPResponse<Data>) -> ClientResult<HTTPResponse<Data>> {
			return { response in
				if codes.contains(response.URLResponse.statusCode) {
					return .failure(ClientError.unauthorized)
				} else {
					return .success(response)
				}
			}
		}

		public static func getHeader(at key: String, caseSensitive: Bool = false) -> (HTTPResponse<Data>) -> ClientResult<String> {
			return { response in
				let targetHeaders = response.URLResponse.allHeaderFields
					.map(Product.init)
					.map { $0.bimap(
						{ caseSensitive.fold(
							onTrue: $0,
							onFalse: $0.description.lowercased())
					},
						f.identity)
					}
					.map { $0.unwrap }
					|> { Dictionary.init($0, uniquingKeysWith: f.first) }

				let targetKey = caseSensitive.fold(
					onTrue: key,
					onFalse: key.lowercased())

				guard let header = targetHeaders[targetKey] as? String
					else { return ClientResult<String>.failure(ClientError.invalidHeader(targetKey)) }
				return .success(header)
			}
		}
	}

	public enum Output {

		public static func check<OutputType, CheckedType>(at getCheckedType: @escaping (OutputType) -> CheckedType, errorStrategy: @escaping (CheckedType) -> ClientResult<CheckedType>) -> (OutputType) -> ClientResult<OutputType> {
			return { output in errorStrategy(getCheckedType(output)).map { _ in output } }
		}

		public static func check<OutputType>(errorStrategy: @escaping (OutputType) -> ClientResult<OutputType>) -> (OutputType) -> ClientResult<OutputType> {
			return check(at: f.identity, errorStrategy: errorStrategy)
		}

		public static func getElement<T>(type: T.Type, at path: Path) -> ([String:Any]) -> ClientResult<T> {
			return { PathTo<T>(root: $0).get(path).mapError(ClientError.noValueAtPath) }
		}

		public static func getElement<T>(at index: Int) -> ([T]) -> ClientResult<T> {
			return { array in
				if array.indices.contains(index) {
					return .success(array[index])
				} else {
					return .failure(ClientError.noValueInArray(index: index))
				}
			}
		}
	}

	public enum Error {
		
		public static func noResults<T>() -> ([T]) -> ClientResult<[T]> {
			return { results in
				if results.count > 0 {
					return .success(results)
				} else {
					return .failure(ClientError.noResults)
				}
			}
		}

		public static func message(_ expectedText: String) -> (String) ->  ClientResult<String> {
			return { text in
				if text == expectedText {
					return .failure(ClientError.errorMessage(text))
				} else {
					return .success(text)
				}
			}
		}

		public static func messageForKey(_ errorKey: String) -> ([String:Any]) -> ClientResult<[String:Any]> {
			return { plist in
				guard let errorMessage = plist[errorKey] as? String else { return .success(plist) }
				return .failure(ClientError.errorMessage(errorMessage))
			}
		}

		public static func messageForPath(_ errorPath: Path) -> ([String:Any]) -> ClientResult<[String:Any]> {
			return { plist in
				guard let errorMessage = PathTo<String>(root: plist).get(errorPath).toOptionalValue else { return .success(plist) }
				return .failure(.errorMessage(errorMessage))
			}
		}

		public static func multipleMessagesArray(errorsKey: String, messageKey: String) -> ([String:Any]) -> ClientResult<[String:Any]> {
			return { plist in
				guard let errorsArray = plist[errorsKey] as? [[String:Any]] else { return .success(plist) }
				let messages = errorsArray
					.compactMap { (dict: [String:Any]) -> String? in dict[messageKey] as? String }
				guard messages.count > 0 else { return .success(plist) }
				return .failure(ClientError.errorMessages(messages))
			}
		}

		public static func multipleMessagesDictionary(errorsKey: String, messageKey: String) -> ([String:Any]) -> ClientResult<[String:Any]> {
			return { plist in
				guard let errorsDict = plist[errorsKey] as? [String:[String:Any]] else { return .success(plist) }
				let messages = errorsDict
					.map { (key: String, value: [String:Any]) -> [String:Any] in value  }
					.compactMap { (dict: [String:Any]) -> String? in dict[messageKey] as? String }
				guard messages.count > 0 else { return .success(plist) }
				return .failure(ClientError.errorMessages(messages))
			}
		}

		public static func multipleMessagesArrayOfDictionary(errorsKey: String, messageKey: String) -> ([String:Any]) -> ClientResult<[String:Any]> {
			return { plist in
				guard let errorsArray = plist[errorsKey] as? [[String:Any]] else { return .success(plist) }
				let messages = errorsArray
					.compactMap { (dict: [String:Any]) -> String? in
						dict.values.first
							.flatMap { (value: Any) -> [String:Any]? in value as? [String:Any] }
							.flatMap { (dict: [String:Any]) -> String? in dict[messageKey] as? String }
				}
				guard messages.count > 0 else { return .success(plist) }
				return .failure(ClientError.errorMessages(messages))
			}
		}

		public static func multipleMessagesDictionaryOfDictionary(errorsKey: String, messageKey: String) -> ([String:Any]) -> ClientResult<[String:Any]> {
			return { plist in
				guard let errorsDict = plist[errorsKey] as? [String:Any] else { return .success(plist) }
				let messages = errorsDict
					.map { (key: String, value: Any) -> Any in value }
					.compactMap { (value: Any) -> [String:Any]? in value as? [String:Any] }
					.compactMap { (dict: [String:Any]) -> String? in dict[messageKey] as? String }
				guard messages.count > 0 else { return .success(plist) }
				return .failure(ClientError.errorMessages(messages))
			}
		}

		public static func arrayForKey(_ errorKey: String) -> ([String:Any]) -> ClientResult<[String:Any]> {
			return { plist in
				guard let errorArray = plist[errorKey] as? [String] else { return .success(plist) }
				return .failure(ClientError.errorMessages(errorArray))
			}
		}

		public static func plistForKey(_ errorKey: String) -> ([String:Any]) -> ClientResult<[String:Any]> {
			return { plist in
				guard let errorPlist = plist[errorKey] as? [String:Any] else { return .success(plist) }
				return .failure(ClientError.errorPlist(errorPlist))
			}
		}
	}
}
