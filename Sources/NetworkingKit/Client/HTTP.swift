import Foundation
import Abstract
import FunctionalKit

// sourcery: prism
// sourcery: match
public enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
	case put = "PUT"
	case patch = "PATCH"
	case delete = "DELETE"
}

// sourcery: equatable
// sourcery: lens
public struct HTTPRequest {
	public var identifier: String
	public var urlComponents: URLComponents
	public var method: HTTPMethod
	public var headers: [String:String]
	public var body: Data?

	// sourcery:inline:Request.Init
    public init(identifier: String, urlComponents: URLComponents, method: HTTPMethod, headers: [String: String], body: Data?) {
        self.identifier = identifier
        self.urlComponents = urlComponents
        self.method = method
        self.headers = headers
        self.body = body
    }
	// sourcery:end

    @available(*, deprecated, message: "Please use correct version with paramenter 'queryStringParameters: [Pair<String,Any>]?'")
	public init(identifier: String, configuration: ConnectionConfiguration, method: HTTPMethod, additionalHeaders: [String:String]?, path: String?, queryStringParameters: [String:Any]?, body: Data?) {
		self.init(
			identifier: identifier,
			urlComponents: URLComponents()
				.resetTo(
					scheme: configuration.scheme,
					host: configuration.host,
					port: configuration.port,
					rootPath: configuration.rootPath)
				.append(path: path.get(or: ""))
				.setQueryString(parameters: queryStringParameters ?? [:]),
			method: method,
			headers: configuration.defaultHeaders.get(or: [:]).merging(additionalHeaders.get(or: [:]), uniquingKeysWith: f.second),
			body: body)
	}
    
    public init(identifier: String, configuration: ConnectionConfiguration, method: HTTPMethod, additionalHeaders: [String:String]?, path: String?, queryString: [Pair<String,Any>]?, body: Data?) {
        self.init(
            identifier: identifier,
            urlComponents: URLComponents()
                .resetTo(
                    scheme: configuration.scheme,
                    host: configuration.host,
                    port: configuration.port,
                    rootPath: configuration.rootPath)
                .append(path: path.get(or: ""))
                .setQueryString(parameters: queryString ?? []),
            method: method,
            headers: configuration.defaultHeaders.get(or: [:]).merging(additionalHeaders.get(or: [:]), uniquingKeysWith: f.second),
            body: body)
    }

	public func getURLRequestWriter(cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData, timeoutInterval: TimeInterval = 20) -> ClientResult<Writer<ConnectionInfo,URLRequest>> {
		guard let url = urlComponents.url else {
			return ClientResult.failure(.request(urlComponents))
		}

		let m_request = NSMutableURLRequest(
			url: url,
			cachePolicy: cachePolicy,
			timeoutInterval: timeoutInterval)
		m_request.httpMethod = method.rawValue
		m_request.allHTTPHeaderFields = headers
		m_request.httpBody = body

		let originalRequest = m_request.copy() as! URLRequest

		let info = ConnectionInfo.init(
            connectionName: identifier,
            request: ConnectionInfo.Request.init(
                urlComponents: urlComponents,
                originalRequest: originalRequest,
                bodyStringRepresentation: nil),
            response: .empty)

		return ClientResult.pure(Writer.init(log: info, value: originalRequest))
	}
}

// sourcery: lens
public struct HTTPResponse<Output> {
	public var URLResponse: HTTPURLResponse
	public var output: Output

	// sourcery:inline:HTTPResponse.Init
	    public init(URLResponse: HTTPURLResponse, output: Output) {
	        self.URLResponse = URLResponse
	        self.output = output
	    }
	// sourcery:end

	public var toWriter: Writer<ConnectionInfo,HTTPResponse> {
		return Writer.pure(self)
			.tell(ConnectionInfo.empty
				.with { $0.response.serverResponse = self.URLResponse})
			.tell(ConnectionInfo.empty
				.with {
					$0.response.serverOutput = self.output as? Data
					$0.response.downloadedFileURL = self.output as? URL
			})
	}
}
