import Foundation
import Abstract
import FunctionalKit

public enum ConnectionAction {
	case cancel
}

public typealias ClientWriter<T> = Writer<ConnectionInfo,ClientResult<T>>
public typealias ClientResource<T> = Future<ClientWriter<T>>
public typealias ClientResourceInContext<T> = Writer<Coeffect<ConnectionAction>,ClientResource<T>>

public extension f {
	static func failed<T>(with error: ClientError) -> ClientResource<T> {
		return ClientResource<T>.pure(Writer.pure(Result.failure(error)))
	}

	static func succeeded<T>(with value: T) -> ClientResource<T> {
		return ClientResource<T>.pure(Writer.pure(Result.success(value)))
	}

	static func failable<T>(from closure: () throws -> ClientResource<T>) rethrows -> ClientResource<T> {
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
}

public typealias Response = (optData: Data?, optResponse: URLResponse?, optError: Error?)
public typealias Connection = (URLRequest) -> ClientResourceInContext<Response>

// sourcery: equatable
// sourcery: lens
public struct ConnectionConfiguration {
	public let scheme: String
	public let host: String
	public let port: Int?
	public let rootPath: String?
	public let defaultHeaders: [String:String]?

	// sourcery:inline:ConnectionConfiguration.Init
    public init(scheme: String, host: String, port: Int?, rootPath: String?, defaultHeaders: [String: String]?) {
        self.scheme = scheme
        self.host = host
        self.port = port
        self.rootPath = rootPath
        self.defaultHeaders = defaultHeaders
    }
	// sourcery:end
}

// sourcery: lens
public struct ConnectionContext<Environment> {
	public let connection: Connection
	public let configuration: ConnectionConfiguration
	public let environment: Environment

    public init(connection: @escaping Connection, configuration: ConnectionConfiguration, environment: Environment) {
        self.connection = connection
        self.configuration = configuration
        self.environment = environment
    }
}

public typealias ConnectionReader<Environment,T> = Reader<ConnectionContext<Environment>,T>
public typealias ResourceReader<Environment,T> = ConnectionReader<Environment,Future<T>>

public typealias RequestFunction<Environment,RequestModel,ResponseModel> = (RequestModel) -> ResourceReader<Environment,ClientResult<ResponseModel>>
