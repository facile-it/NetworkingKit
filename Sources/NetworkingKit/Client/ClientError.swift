import Foundation
import FunctionalKit

public typealias ClientResult<T> = Result<T, ClientError>

// sourcery: prism
// sourcery: match
public enum ClientError: Error {
	case generic(NSError)
	case connection(NSError)
	case request(URLComponents)
	case noData
	case noResponse
	case invalidHTTPCode(Int)
	case invalidHeader(String)
    
    @available(*, deprecated, message: "Use Codable protocol instead")
	case noValueAtPath(PathError)
    
	case noValueInArray(index: Int)
	case noResults
	case invalidData(String)
	case errorMessage(String)
	case errorMessages([String])
	case errorPlist([String:Any])
	case unauthorized
	
    @available(*, deprecated, message: "Use Codable protocol instead")
    case serialization(SerializationError)
    
    @available(*, deprecated, message: "Use Codable protocol instead")
	case deserialization(DeserializationError)
	
    case undefined(Error)

	public static let errorDomain = "Client"
	public static let errorInfoKey = "ErrorInfo"
}

// MARK: - Public

public extension ClientError {
	var getNSError: NSError {
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

extension ClientError: Equatable {
	public static func == (lhs: ClientError, rhs: ClientError) -> Bool {
		switch (lhs,rhs) {
		case (.generic(let lhs), .generic(let rhs)):
			return lhs == rhs
		case (.connection(let lhs), .connection(let rhs)):
			return lhs == rhs
		case (.request(let lhs), .request(let rhs)):
			return lhs == rhs
		case (.noData, .noData):
			return true
		case (.noResponse, .noResponse):
			return true
		case (.invalidHTTPCode(let lhs), .invalidHTTPCode(let rhs)):
			return lhs == rhs
		case (.invalidHeader(let lhs), .invalidHeader(let rhs)):
			return lhs == rhs
		case (.noValueAtPath(let lhs), .noValueAtPath(let rhs)):
			return lhs == rhs
		case (.noValueInArray(let lhs), .noValueInArray(let rhs)):
			return lhs == rhs
		case (.noResults, .noResults):
			return true
		case (.invalidData(let lhs), .invalidData(let rhs)):
			return lhs == rhs
		case (.errorMessage(let lhs), .errorMessage(let rhs)):
			return lhs == rhs
		case (.errorMessages(let lhs), .errorMessages(let rhs)):
			return lhs == rhs
		case (.errorPlist(let lhs), .errorPlist(let rhs)):
			return lhs.isEqual(to: rhs, considering: { "\($0)" == "\($1)" })
		case (.unauthorized, .unauthorized):
			return true
		case (.serialization(let lhs), .serialization(let rhs)):
			return lhs == rhs
		case (.deserialization(let lhs), .deserialization(let rhs)):
			return lhs == rhs
		case (.undefined(let lhs), .undefined(let rhs)):
			return "\(lhs)" == "\(rhs)"
		default: return false
		}
	}
}

extension ClientError: CustomStringConvertible {
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
}
