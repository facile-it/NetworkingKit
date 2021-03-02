import Foundation
import Abstract
import FunctionalKit
#if SWIFT_PACKAGE
    import Operadics
#endif

// sourcery: equatable
// sourcery: lens
public struct ConnectionInfo {
	public var connectionName: String?
	public var request: Request
	public var response: Response

	// sourcery: equatable
	// sourcery: lens
	public struct Request {
		public var urlComponents: URLComponents?
		public var originalRequest: URLRequest?
		public var bodyStringRepresentation: String?
	}

	// sourcery: equatable
	// sourcery: lens
	public struct Response {
		public var connectionError: NSError?
		public var serverResponse: HTTPURLResponse?
		public var serverOutput: Data?
		public var downloadedFileURL: URL?
	}
}

// MARK: - Public

public extension ConnectionInfo {
	func with(transform: (inout ConnectionInfo) -> ()) -> ConnectionInfo {
		var m_self = self
		transform(&m_self)
		return m_self
	}
}

extension ConnectionInfo: Monoid {
	public static var empty: ConnectionInfo {
		return ConnectionInfo.init(
			connectionName: nil,
			request: Request.empty,
			response: Response.empty)
	}

	public static func <> (_ left: ConnectionInfo, _ right: ConnectionInfo) -> ConnectionInfo {
		return ConnectionInfo.init(
			connectionName: right.connectionName ?? left.connectionName,
			request: right.request <> left.request,
			response: right.response <> left.response)
	}
}

extension ConnectionInfo: JSONObjectConvertible {
    
    @available(*, deprecated, message: "Use Codable protocol instead")
	public var toJSONObject: JSONObject {
		let connName: JSONObject? = connectionName.map(JSONObject.string)

		return JSONObject.array([.dict(["Connection Name" : connName.get(or: .null)])])
			<> request.toJSONObject
			<> response.toJSONObject
	}
}

extension ConnectionInfo.Request: Monoid {
	public static var empty: ConnectionInfo.Request {
		return ConnectionInfo.Request.init(
			urlComponents: nil,
			originalRequest: nil,
			bodyStringRepresentation: nil)
	}

	public static func <> (_ left: ConnectionInfo.Request, _ right: ConnectionInfo.Request) -> ConnectionInfo.Request {
		return ConnectionInfo.Request.init(
			urlComponents: left.urlComponents ?? right.urlComponents,
			originalRequest: left.originalRequest ?? right.originalRequest,
			bodyStringRepresentation: left.bodyStringRepresentation ?? right.bodyStringRepresentation)
	}
}

extension ConnectionInfo.Request: JSONObjectConvertible {
    
    @available(*, deprecated, message: "Use Codable protocol instead")
	public var toJSONObject: JSONObject {
		let val1 = Product.init("Request URL Scheme",
								urlComponents.flatMap { $0.scheme }.map(JSONObject.string))
		let val2 = Product.init("Request URL Host",
								urlComponents.flatMap { $0.host }.map(JSONObject.string))
		let val3 = Product.init("Request URL Port",
								urlComponents.flatMap { $0.port }.map(JSONObject.number))
		let val4 = Product.init("Request URL Path",
								urlComponents.map { JSONObject.string($0.path) })
		let val5 = Product.init("Request URL Query String",
								urlComponents.flatMap { $0.query }.map(JSONObject.string))
		let val6 = Product.init("Request URL Full String",
								originalRequest.flatMap { $0.url }.flatMap { $0.absoluteString.removingPercentEncoding }.map(JSONObject.string))
		let val7 = Product.init("Request HTTP Method",
								originalRequest.flatMap { $0.httpMethod }.map(JSONObject.string))
		let val8 = Product.init("Request HTTP Headers",
								originalRequest.flatMap { $0.allHTTPHeaderFields }?.mapValues(JSONObject.string).map { JSONObject.dict([$0.key:$0.value]) }.reduce(.empty,<>))
		let val9 = Product.init("Request Body String Representation",
								self.requestBodyStringRepresentation(bodyStringRepresentation: bodyStringRepresentation, originalRequest: originalRequest))
		let val10 = Product.init("Request Body Byte Length",
								 originalRequest.flatMap { $0.httpBody }.map{ JSONObject.number($0.count) })

		return [val1,val2,val3,val4,val5,val6,val7,val8,val9,val10]
			.toJSONDict
			|> JSONObject.array
	}
}

extension ConnectionInfo.Response: Monoid {
	public static var empty: ConnectionInfo.Response {
		return ConnectionInfo.Response(
			connectionError: nil,
			serverResponse: nil,
			serverOutput: nil,
			downloadedFileURL: nil)
	}

	public static func <> (_ left: ConnectionInfo.Response, _ right: ConnectionInfo.Response) -> ConnectionInfo.Response {
		return ConnectionInfo.Response(
			connectionError: right.connectionError ?? left.connectionError,
			serverResponse: right.serverResponse ?? left.serverResponse,
			serverOutput: right.serverOutput ?? left.serverOutput,
			downloadedFileURL: right.downloadedFileURL ?? left.downloadedFileURL)
	}
}

extension ConnectionInfo.Response: JSONObjectConvertible {
    
    @available(*, deprecated, message: "Use Codable protocol instead")
	public var toJSONObject: JSONObject {
		let val1 = Product("Connection Error",
						   connectionError.map { JSONObject.dict([
							"Code" : .number($0.code),
							"Domain" : .string($0.domain),
							"UserInfo" : JSONObject.with($0.userInfo)
								.fold(onSuccess: f.identity,
									  onFailure: { _ in .null })])})
		let val2 = Product("Response Status Code",
						   serverResponse.flatMap { $0.statusCode }.map(JSONObject.number))
		let val3 = Product("Response HTTP Headers",
						   serverResponse?.allHeaderFields
							.map { (key: AnyHashable, value: Any) -> JSONObject in
								guard let key = key.base as? String else { return JSONObject.null }
								return JSONObject.dict([key : JSONObject.with(value)
									.fold(onSuccess: f.identity,
										  onFailure: { _ in .null })])}
							.reduce(.empty, <>))
		let val4 = Product("Response Body",
						   serverOutput
							.flatMap { (try? JSONSerialization.jsonObject(with: $0, options: .allowFragments))
								.map(JSONObject.with)?
								.fold(onSuccess: f.identity,
									  onFailure: { _ in nil })
								?? String(data: $0, encoding: String.Encoding.utf8).map(JSONObject.string)})
		let val5 = Product("Downloaded File URL",
						   downloadedFileURL.map { JSONObject.string($0.absoluteString) })

		return [val1,val2,val3,val4,val5].toJSONDict
			|> JSONObject.array
	}
}

// MARK: - Private

private extension ConnectionInfo.Request {
    
    @available(*, deprecated, message: "Use Codable protocol instead")
	func requestBodyStringRepresentation(bodyStringRepresentation: String?, originalRequest: URLRequest?) -> JSONObject? {
		let bodyString1 = bodyStringRepresentation.map(JSONObject.string)
		let bodyString2 = (originalRequest?.httpBody).flatMap { (try? JSONSerialization.jsonObject(with: $0, options: .allowFragments))
			.map(JSONObject.with)?
			.fold(onSuccess: f.identity,
				  onFailure: { _ in nil }) }
		let bodyString3 = (originalRequest?.httpBody).flatMap { String(data: $0, encoding: String.Encoding.utf8).map(JSONObject.string) }

		return bodyString1 ?? bodyString2 ?? bodyString3
	}
}
