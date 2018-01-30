
import FunctionalKit
import Abstract

//: ------------------------

extension URLComponents {
	public func resetTo(scheme: String, host: String, port: Int?, rootPath: String?) -> URLComponents {
		var m_self = self
		m_self.scheme = scheme
		m_self.host = host
		m_self.port = port
		m_self.path = rootPath ?? ""
		return m_self
	}

	public func append(path: String) -> URLComponents {
		var m_self = self
		var newPath = m_self.path
		newPath.append(path)
		m_self.path = newPath
		return m_self
	}

	public func setQueryString(parameters: [String:Any]) -> URLComponents {
		var m_self = self
		guard parameters.count > 0 else {
			m_self.queryItems = nil
			return m_self
		}
		m_self.queryItems = parameters.map { (key, value) in URLQueryItem(name: key, value: "\(value)") }
		return m_self
	}
}

//: ------------------------

extension Request {
	public func getHTTPResponse(connection: @escaping Connection) -> ConnectionWriter<HTTPResponse<Data>> {
		let result = getURLRequestWriter()

		guard let writer = result.toOptionalValue else {
			return ConnectionWriter<HTTPResponse<Data>>.pure(Future.pure(Writer.pure(ClientResult.failure(result.toOptionalError!))))
		}

		let (urlRequestInfo,request) = writer.run

		return connection(request).map {
			$0.flatMapTT {
				let optData = $0.optData
				let optResponse = $0.optResponse as? HTTPURLResponse
				let optError = $0.optError as NSError?

				let info = urlRequestInfo.with {
					$0.response.connectionError = optError
					$0.response.serverResponse = optResponse
					$0.response.serverOutput = optData
				}

				if let error = optError {
					return Resource<HTTPResponse<Data>>.pure(Writer.init(
						log: info,
						value: .failure(.connection(error))))
				} else if let response = optResponse {
					if let data = optData {
						return Resource<HTTPResponse<Data>>.pure(Writer.init(
							log: info,
							value: .success(HTTPResponse<Data>(URLResponse: response, output: data))))
					} else {
						return Resource<HTTPResponse<Data>>.pure(Writer.init(
							log: info,
							value: .failure(.noData)))
					}
				} else {
					return Resource<HTTPResponse<Data>>.pure(Writer.init(
						log: info,
						value: .failure(.noResponse)))
				}
			}
		}
	}

	public static func get(
		identifier: String,
		configuration: ClientConfiguration,
		path: String,
		additionalHeaders: [String:String]? = nil,
		queryStringParameters: [String:Any]? = nil,
		connection: @escaping Connection) -> ConnectionWriter<HTTPResponse<Data>> {
		return Request(
			identifier: identifier,
			configuration: configuration,
			method: .get,
			additionalHeaders: additionalHeaders,
			path: path,
			queryStringParameters: queryStringParameters,
			body: nil)
			.getHTTPResponse(connection: connection)
	}

	public static func post(
		identifier: String,
		configuration: ClientConfiguration,
		path: String,
		body: Data?,
		additionalHeaders: [String:String]? = nil,
		connection: @escaping Connection) -> ConnectionWriter<HTTPResponse<Data>> {
		return Request(
			identifier: identifier,
			configuration: configuration,
			method: .post,
			additionalHeaders: additionalHeaders,
			path: path,
			queryStringParameters: nil,
			body: body)
			.getHTTPResponse(connection: connection)
	}

	public static func put(
		identifier: String,
		configuration: ClientConfiguration,
		path: String,
		body: Data?,
		additionalHeaders: [String:String]? = nil,
		connection: @escaping Connection) -> ConnectionWriter<HTTPResponse<Data>> {
		return Request(
			identifier: identifier,
			configuration: configuration,
			method: .put,
			additionalHeaders: additionalHeaders,
			path: path,
			queryStringParameters: nil,
			body: body)
			.getHTTPResponse(connection: connection)
	}
}

//: ------------------------

extension Array where Element: ProductType, Element.FirstType == String, Element.SecondType == Optional<JSONObject> {
    public var toJSONDict: Array<JSONObject> {
        return self
            .map { $0.mapSecond { optJSON in optJSON.get(or: .null) }}
            .map { JSONObject.dict([$0.first:$0.second]) }
    }
}

//: ------------------------

extension Sequence where SubSequence: Sequence, SubSequence.Iterator.Element == Iterator.Element {
    func accumulate(combine: (Iterator.Element, Iterator.Element) throws -> Iterator.Element) rethrows -> Iterator.Element? {
        guard let nonOptHead = head, let nonOptTail = tail else { return head }
        return try nonOptTail.reduce(nonOptHead, combine)
    }
}

extension Sequence where Iterator.Element: Monoid, SubSequence: Sequence, SubSequence.Iterator.Element == Iterator.Element {
    func composeAll(separator: Iterator.Element = .empty) -> Iterator.Element {
        guard let nonOptHead = head, let nonOptTail = tail else { return .empty }
        return nonOptTail.reduce(nonOptHead) { $0 <> separator <> $1 }
    }
}
