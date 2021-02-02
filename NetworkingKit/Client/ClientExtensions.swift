import Foundation
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

    @available(*, deprecated, message: "Please use correct version 'setQueryString(parameters: [Pair<String,Any>]) -> URLComponents'")
	public func setQueryString(parameters: [String:Any]) -> URLComponents {
		var m_self = self
		guard parameters.count > 0 else {
			m_self.queryItems = nil
			return m_self
		}

        m_self.queryItems = parameters
            .map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            .sorted { $0.name < $1.name }
        
        return m_self
	}
    
    public func setQueryString(parameters: [Pair<String,Any>]) -> URLComponents {
        var m_self = self
        guard parameters.count > 0 else {
            m_self.queryItems = nil
            return m_self
        }
        
        m_self.queryItems = parameters
            .map { URLQueryItem(name: $0.first, value: "\($0.second)") }
            .sorted { $0.name < $1.name }
        
        return m_self
    }
}

//: ------------------------

extension HTTPRequest {
	public func getHTTPResponse(connection: @escaping Connection) -> ClientResourceInContext<HTTPResponse<Data>> {
		let result = getURLRequestWriter()

		guard let writer = result.toOptionalValue() else {
			return ClientResourceInContext<HTTPResponse<Data>>.pure(Future.pure(Writer.pure(ClientResult.failure(result.toOptionalError()!))))
		}

		let (urlRequestInfo,request) = (writer.log, writer.value)

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
					return ClientResource<HTTPResponse<Data>>.pure(Writer.init(
						log: info,
						value: .failure(.connection(error))))
				} else if let response = optResponse {
					if let data = optData {
						return ClientResource<HTTPResponse<Data>>.pure(Writer.init(
							log: info,
							value: .success(HTTPResponse<Data>(URLResponse: response, output: data))))
					} else {
						return ClientResource<HTTPResponse<Data>>.pure(Writer.init(
							log: info,
							value: .failure(.noData)))
					}
				} else {
					return ClientResource<HTTPResponse<Data>>.pure(Writer.init(
						log: info,
						value: .failure(.noResponse)))
				}
			}
		}
	}

    @available(*, deprecated, message: "Please use correct version with paramenter 'queryStringParameters: [Pair<String,Any>]?'")
	public static func get(
		identifier: String,
		configuration: ConnectionConfiguration,
		path: String,
		additionalHeaders: [String:String]? = nil,
		queryStringParameters: [String:Any]? = nil,
		connection: @escaping Connection) -> ClientResourceInContext<HTTPResponse<Data>> {
		return HTTPRequest(
			identifier: identifier,
			configuration: configuration,
			method: .get,
			additionalHeaders: additionalHeaders,
			path: path,
			queryStringParameters: queryStringParameters,
			body: nil)
			.getHTTPResponse(connection: connection)
	}
    
    public static func get(
        identifier: String,
        configuration: ConnectionConfiguration,
        path: String,
        additionalHeaders: [String:String]? = nil,
        queryString: [Pair<String,Any>]? = nil,
        connection: @escaping Connection) -> ClientResourceInContext<HTTPResponse<Data>> {
        return HTTPRequest(
            identifier: identifier,
            configuration: configuration,
            method: .get,
            additionalHeaders: additionalHeaders,
            path: path,
            queryString: queryString,
            body: nil)
            .getHTTPResponse(connection: connection)
    }

	public static func post(
		identifier: String,
		configuration: ConnectionConfiguration,
		path: String,
		body: Data?,
		additionalHeaders: [String:String]? = nil,
		connection: @escaping Connection) -> ClientResourceInContext<HTTPResponse<Data>> {
		return HTTPRequest(
			identifier: identifier,
			configuration: configuration,
			method: .post,
			additionalHeaders: additionalHeaders,
			path: path,
			queryString: nil,
			body: body)
			.getHTTPResponse(connection: connection)
	}

	public static func put(
		identifier: String,
		configuration: ConnectionConfiguration,
		path: String,
		body: Data?,
		additionalHeaders: [String:String]? = nil,
		connection: @escaping Connection) -> ClientResourceInContext<HTTPResponse<Data>> {
		return HTTPRequest(
			identifier: identifier,
			configuration: configuration,
			method: .put,
			additionalHeaders: additionalHeaders,
			path: path,
			queryString: nil,
			body: body)
			.getHTTPResponse(connection: connection)
	}
}

//: ------------------------

extension Array where Element: ProductType, Element.FirstType == String, Element.SecondType == Optional<JSONObject> {
    
    @available(*, deprecated, message: "Use Codable protocol instead")
    public var toJSONDict: Array<JSONObject> {
        return self
            .map { $0.mapSecond { optJSON in optJSON.get(or: .null) }}
            .map { JSONObject.dict([$0.first:$0.second]) }
    }
}

//: ------------------------

extension Collection {
    func accumulate(combine: (Iterator.Element, Iterator.Element) throws -> Iterator.Element) rethrows -> Iterator.Element? {
        guard let nonOptHead = head, let nonOptTail = tail else { return head }
        return try nonOptTail.reduce(nonOptHead, combine)
    }
}

extension Collection where Iterator.Element: Monoid {
    func composeAll(separator: Iterator.Element = .empty) -> Iterator.Element {
        guard let nonOptHead = head, let nonOptTail = tail else { return .empty }
        return nonOptTail.reduce(nonOptHead) { $0 <> separator <> $1 }
    }
}
