import Abstract
import FunctionalKit

public enum ConnectionAction {
	case cancel
}

public typealias ConnectionActionHandler = Handler<ConnectionAction>

public typealias ClientResult<T> = Result<ClientError,T>
public typealias ClientWriter<T> = Writer<ConnectionInfo,ClientResult<T>>
public typealias Resource<T> = Future<ClientWriter<T>>
public typealias Response = (optData: Data?, optResponse: URLResponse?, optError: Error?)
public typealias ConnectionWriter<T> = Writer<ConnectionActionHandler,Resource<T>>
public typealias Connection = (URLRequest) -> ConnectionWriter<Response>

public func failed<T>(with error: ClientError) -> Resource<T> {
	return Resource<T>.pure(Writer.pure(Result.failure(error)))
}

public func succeeded<T>(with value: T) -> Resource<T> {
	return Resource<T>.pure(Writer.pure(Result.success(value)))
}

public func failable<T>(from closure: () throws -> Resource<T>) rethrows -> Resource<T> {
	do {
		return try closure()
	}
	catch let error as ClientError {
		return failed(with: error)
	}
	catch let error {
		throw error
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

//: ------------------------

public struct ConnectionInfo: Monoid, Equatable, JSONObjectConvertible {
	public var connectionName: String?
    public var request: Request
    public var response: Response
    
    public func with(transform: (inout ConnectionInfo) -> ()) -> ConnectionInfo {
        var m_self = self
        transform(&m_self)
        return m_self
    }
    
    public static var empty: ConnectionInfo {
        return ConnectionInfo(
            connectionName: nil,
            request: Request.empty,
            response: Response.empty)
    }
    
    public static func <> (_ left: ConnectionInfo, _ right: ConnectionInfo) -> ConnectionInfo {
        return ConnectionInfo(
            connectionName: right.connectionName ?? left.connectionName,
            request: right.request <> left.request,
            response: right.response <> left.response)
    }
    
    public static func == (left: ConnectionInfo, right: ConnectionInfo) -> Bool {
        return left.connectionName == right.connectionName
            && left.request == right.request
            && left.response == right.response
    }
    
    public var toJSONObject: JSONObject {
        let connName: JSONObject? = connectionName.map(JSONObject.string)
        
        return JSONObject.array([.dict(["Connection Name" : connName.get(or: .null)])])
            <> request.toJSONObject
            <> response.toJSONObject
    }
    
    public struct Request: Monoid, Equatable, JSONObjectConvertible {
        public var urlComponents: URLComponents?
        public var originalRequest: URLRequest?
        public var bodyStringRepresentation: String?
        
        public static var empty: Request {
            return Request(
                urlComponents: nil,
                originalRequest: nil,
                bodyStringRepresentation: nil)
        }
        
        public static func <> (_ left: Request, _ right: Request) -> Request {
            return Request(
                urlComponents: left.urlComponents ?? right.urlComponents,
                originalRequest: left.originalRequest ?? right.originalRequest,
                bodyStringRepresentation: left.bodyStringRepresentation ?? right.bodyStringRepresentation)
        }
        
        public static func == (_ left: Request, _ right: Request) -> Bool {
            return right.urlComponents == left.urlComponents
                && right.originalRequest == left.originalRequest
                && right.bodyStringRepresentation == left.bodyStringRepresentation
        }
        
        public var toJSONObject: JSONObject {
            let val1 = Product("Request URL Scheme",
                               urlComponents.flatMap { $0.scheme }.map(JSONObject.string))
            let val2 = Product("Request URL Host",
                               urlComponents.flatMap { $0.host }.map(JSONObject.string))
            let val3 = Product("Request URL Port",
                               urlComponents.flatMap { $0.port }.map(JSONObject.number))
            let val4 = Product("Request URL Path",
                               urlComponents.map { JSONObject.string($0.path) })
            let val5 = Product("Request URL Query String",
                               urlComponents.flatMap { $0.query }.map(JSONObject.string))
            let val6 = Product("Request URL Full String",
                               originalRequest.flatMap { $0.url }.flatMap { $0.absoluteString.removingPercentEncoding }.map(JSONObject.string))
            let val7 = Product("Request HTTP Method",
                               originalRequest.flatMap { $0.httpMethod }.map(JSONObject.string))
            let val8 = Product("Request HTTP Headers",
                               originalRequest.flatMap { $0.allHTTPHeaderFields }?.mapValues(JSONObject.string).map { JSONObject.dict([$0.key:$0.value]) }.reduce(.empty,<>))
            let val9 = Product("Request Body String Representation",
                               self.requestBodyStringRepresentation(bodyStringRepresentation: bodyStringRepresentation, originalRequest: originalRequest))
            let val10 = Product("Request Body Byte Length",
                                originalRequest.flatMap { $0.httpBody }.map{ JSONObject.number($0.count) })
            
            return [val1,val2,val3,val4,val5,val6,val7,val8,val9,val10].toJSONDict
                |> JSONObject.array
        }
        
        private func requestBodyStringRepresentation(bodyStringRepresentation: String?, originalRequest: URLRequest?) -> JSONObject? {
            let bodyString1 = bodyStringRepresentation.map(JSONObject.string)
            let bodyString2 = (originalRequest?.httpBody).flatMap { (try? JSONSerialization.jsonObject(with: $0, options: .allowFragments))
                .map(JSONObject.with)?
                .fold(onSuccess: f.identity,
                      onFailure: { _ in nil }) }
            let bodyString3 = (originalRequest?.httpBody).flatMap { String(data: $0, encoding: String.Encoding.utf8).map(JSONObject.string) }
            
            return bodyString1 ?? bodyString2 ?? bodyString3
        }
    }
    
    public struct Response: Monoid, Equatable, JSONObjectConvertible {
        public var connectionError: NSError?
        public var serverResponse: HTTPURLResponse?
        public var serverOutput: Data?
        public var downloadedFileURL: URL?
        
        public static var empty: Response {
            return Response(
                connectionError: nil,
                serverResponse: nil,
                serverOutput: nil,
                downloadedFileURL: nil)
        }
        
        public static func <> (_ left: Response, _ right: Response) -> Response {
            return Response(
                connectionError: right.connectionError ?? left.connectionError,
                serverResponse: right.serverResponse ?? left.serverResponse,
                serverOutput: right.serverOutput ?? left.serverOutput,
                downloadedFileURL: right.downloadedFileURL ?? left.downloadedFileURL)
        }
        
        public static func == (_ left: Response, _ right: Response) -> Bool {
            return left.connectionError == right.connectionError
                && left.serverResponse == right.serverResponse
                && left.serverOutput == right.serverOutput
                && left.downloadedFileURL == right.downloadedFileURL
        }
        
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
}

//: ------------------------

public enum HTTPMethod {
	case get
	case post
	case put
	case patch
	case delete

	public var stringValue: String {
		switch self {
		case .get:
			return "GET"
		case .post:
			return "POST"
		case .put:
			return "PUT"
		case .patch:
			return "PATCH"
		case .delete:
			return "DELETE"
		}
	}
}

//: ------------------------

public struct ClientConfiguration {
	public let scheme: String
	public let host: String
	public let port: Int?
	public let rootPath: String?
	public let defaultHeaders: [String:String]?

	public init(scheme: String, host: String, port: Int?, rootPath: String?, defaultHeaders: [String:String]?) {
		self.scheme = scheme
		self.host = host
		self.port = port
		self.rootPath = rootPath
		self.defaultHeaders = defaultHeaders
	}
}

//: ------------------------

public struct Request {
	public var identifier: String
	public var urlComponents: URLComponents
	public var method: HTTPMethod
	public var headers: [String:String]
	public var body: Data?

	public init(identifier: String, urlComponents: URLComponents, method: HTTPMethod, headers: [String:String], body: Data?) {
		self.identifier = identifier
		self.urlComponents = urlComponents
		self.method = method
		self.headers = headers
		self.body = body
	}

	public init(identifier: String, configuration: ClientConfiguration, method: HTTPMethod, additionalHeaders: [String:String]?, path: String?, queryStringParameters: [String:Any]?, body: Data?) {
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

	public func getURLRequestWriter(cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData, timeoutInterval: TimeInterval = 20) -> ClientResult<Writer<ConnectionInfo,URLRequest>> {
		guard let url = urlComponents.url else {
			return ClientResult.failure(.request(urlComponents))
		}

		let m_request = NSMutableURLRequest(
			url: url,
			cachePolicy: cachePolicy,
			timeoutInterval: timeoutInterval)
		m_request.httpMethod = method.stringValue
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

//: ------------------------

public struct HTTPResponse<Output> {
	public var URLResponse: HTTPURLResponse
	public var output: Output

	public init(URLResponse: HTTPURLResponse, output: Output) {
		self.URLResponse = URLResponse
		self.output = output
	}

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

//: ------------------------
//MARK: - Errors
//: ------------------------

public enum SerializationError: CustomStringConvertible {
	case toJSON
	case toFormURLEncoded

	public var description: String {
		switch self {
		case .toJSON:
			return "SerializationError: JSON"
		case .toFormURLEncoded:
			return "SerializationError: form-url-encoded"
		}
	}

	public static let errorDomain = "Serialization"

	public var getNSError: NSError {
		switch self {
		case .toJSON:
            return NSError(
                domain: SerializationError.errorDomain,
                code: 0,
                userInfo: [NSLocalizedDescriptionKey :  "Cannot serialize into JSON"])
		case .toFormURLEncoded:
			return NSError(
				domain: SerializationError.errorDomain,
				code: 0,
				userInfo: [NSLocalizedDescriptionKey :  "Cannot serialize into form-url-encoded"])
		}
	}
}

//: ------------------------

public enum DeserializationError: CustomStringConvertible {
	case toAny(NSError?)
	case toAnyDict(NSError?)
	case toArray(NSError?)
	case toString

	public var description: String {
		switch self {
		case .toAny:
			return "DeserializationError: toAny"
		case .toAnyDict:
			return "DeserializationError: to[String:Any]"
		case .toArray:
			return "DeserializationError: toArray"
		case .toString:
			return "DeserializationError: toString"
		}
	}

	public static let errorDomain = "Deserialization"

	public var getNSError: NSError {
		switch self {
		case .toAny(let optionalError):
			return optionalError ?? NSError(
				domain: DeserializationError.errorDomain,
				code: 0,
				userInfo: [NSLocalizedDescriptionKey : "Cannot deserialize into 'Any'"])
		case .toAnyDict(let optionalError):
			return optionalError ?? NSError(
				domain: DeserializationError.errorDomain,
				code: 1,
				userInfo: [NSLocalizedDescriptionKey : "Cannot deserialize into '[String:Any]'"])
		case .toArray(let optionalError):
			return optionalError ?? NSError(
				domain: DeserializationError.errorDomain,
				code: 2,
				userInfo: [NSLocalizedDescriptionKey : "Cannot deserialize into 'Array'"])
		case .toString:
			return NSError(
				domain: DeserializationError.errorDomain,
				code: 3,
				userInfo: [NSLocalizedDescriptionKey : "Cannot deserialize into 'String'"])
		}
	}
}

//: ------------------------

public enum ClientError: Error, CustomStringConvertible {
	case generic(NSError)
	case connection(NSError)
	case request(URLComponents)
	case noData
	case noResponse
	case invalidHTTPCode(Int)
	case invalidHeader(String)
	case noValueAtPath(PathError)
	case noValueInArray(index: Int)
	case noResults
	case invalidData(String)
	case errorMessage(String)
	case errorMessages([String])
	case errorPlist([String:Any])
	case unauthorized
	case serialization(SerializationError)
	case deserialization(DeserializationError)
	case undefined(Error)

	public var description: String {
		switch  self {
		case .generic(let error):
			return error.localizedDescription
		case .connection(let error):
			return error.localizedDescription
		case .request:
			return "URLComponents non validi"
		case .noData:
			return "Ricevuti dati vuoti"
		case .noResponse:
			return "Nessuna risposta"
		case .invalidHTTPCode(let statusCode):
			return "Codice HTTP non valido: \(statusCode)"
		case .invalidHeader(let headerKey):
			return "Header non valido alla chiave: \(headerKey)"
		case .noValueAtPath(let error):
			return error.getNSError.localizedDescription
		case .noValueInArray(let index):
			return "Nessun valore trovato all'indice: \(index)"
		case .noResults:
			return "Nessun risultato"
		case .invalidData:
			return "Dati non validi"
		case .errorMessage(let message):
			return message
		case .errorMessages(let messages):
			return messages.composeAll(separator: "\n")
		case .errorPlist:
			return "Errore generico"
		case .unauthorized:
			return "Autorizzazione negata"
		case .serialization(let error):
			return error.description
		case .deserialization(let error):
			return error.description
		case .undefined(let error):
			return error.localizedDescription
		}
	}

	public static let errorDomain = "Client"
	public static let errorInfoKey = "ErrorInfo"

	public var getNSError: NSError {
		switch self {

		case .generic(let error):
			return error

		case .connection(let error):
			return error

		case .request(let components):
			return NSError(
				domain: ClientError.errorDomain,
				code: 0,
				userInfo: [
					ClientError.errorInfoKey : JSONString.from(["URLComponents" : components.debugDescription]),
					NSLocalizedDescriptionKey : description])

		case .noData:
			return NSError(
				domain: ClientError.errorDomain,
				code: 1,
				userInfo: [NSLocalizedDescriptionKey : description])

		case .noResponse:
			return NSError(
				domain: ClientError.errorDomain,
				code: 2,
				userInfo: [NSLocalizedDescriptionKey : description])

		case .invalidHTTPCode(let statusCode):
			return NSError(
				domain: ClientError.errorDomain,
				code: 3,
				userInfo: [
					ClientError.errorInfoKey : JSONString.from(["ReceivedStatusCode" : statusCode]),
					NSLocalizedDescriptionKey : description])

		case .invalidHeader(let headerKey):
			return NSError(
				domain: ClientError.errorDomain,
				code: 4,
				userInfo: [
					ClientError.errorInfoKey : JSONString.from(["InvalidHeaderKey" : headerKey]),
					NSLocalizedDescriptionKey : description])

		case .noValueAtPath(let error):
			return error.getNSError

		case .noValueInArray(let index):
			return NSError(
				domain: ClientError.errorDomain,
				code: 8,
				userInfo: [
					ClientError.errorInfoKey : JSONString.from(["ExpectedIndex" : index]),
					NSLocalizedDescriptionKey : description])

		case .noResults:
			return NSError(
				domain: ClientError.errorDomain,
				code: 9,
				userInfo: [NSLocalizedDescriptionKey : description])

		case .invalidData(let dataString):
			return NSError(
				domain: ClientError.errorDomain,
				code: 10,
				userInfo: [
					ClientError.errorInfoKey : JSONString.from(["DataMessage" : dataString]),
					NSLocalizedDescriptionKey : description])

		case .errorMessage(let message):
			return NSError(
				domain: ClientError.errorDomain,
				code: 11,
				userInfo: [
					ClientError.errorInfoKey : JSONString.from(["ErrorMessage" : message]),
					NSLocalizedDescriptionKey : description])

		case .errorMessages(let messages):
			return NSError(
				domain: ClientError.errorDomain,
				code: 12,
				userInfo: [
					ClientError.errorInfoKey : JSONString.from(["ErrorMessages" : messages]),
					NSLocalizedDescriptionKey : description])

		case .errorPlist(let plist):
			return NSError(
				domain: ClientError.errorDomain,
				code: 13,
				userInfo: [
					ClientError.errorInfoKey : JSONString.from(["ErrorPlist" : plist]),
					NSLocalizedDescriptionKey : description])

		case .unauthorized:
			return NSError(
				domain: ClientError.errorDomain,
				code: 14,
				userInfo: [NSLocalizedDescriptionKey : description])

		case .serialization(let error):
			return error.getNSError

		case .deserialization(let error):
			return error.getNSError

		case .undefined(let error):
			return NSError(domain: "Undefined", code: 0, userInfo: [NSLocalizedDescriptionKey : error.localizedDescription])
		}
	}
}

//: ------------------------
