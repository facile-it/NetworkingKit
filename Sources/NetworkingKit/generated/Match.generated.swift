// Generated using Sourcery 1.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT



import Foundation



public extension ClientError {
	func match<ReturnedType>(
		generic: (NSError) -> ReturnedType, 
		connection: (NSError) -> ReturnedType, 
		request: (URLComponents) -> ReturnedType, 
		noData: () -> ReturnedType, 
		noResponse: () -> ReturnedType, 
		invalidHTTPCode: (Int) -> ReturnedType, 
		invalidHeader: (String) -> ReturnedType, 
		noValueAtPath: (PathError) -> ReturnedType, 
		noValueInArray: (Int) -> ReturnedType, 
		noResults: () -> ReturnedType, 
		invalidData: (String) -> ReturnedType, 
		errorMessage: (String) -> ReturnedType, 
		errorMessages: ([String]) -> ReturnedType, 
		errorPlist: ([String: Any]) -> ReturnedType, 
		unauthorized: () -> ReturnedType, 
		serialization: (SerializationError) -> ReturnedType, 
		deserialization: (DeserializationError) -> ReturnedType, 
		undefined: (Error) -> ReturnedType
		) -> ReturnedType {
		switch self {
			case .generic(let x1):
				return generic(x1)
			case .connection(let x1):
				return connection(x1)
			case .request(let x1):
				return request(x1)
			case .noData:
				return noData()
			case .noResponse:
				return noResponse()
			case .invalidHTTPCode(let x1):
				return invalidHTTPCode(x1)
			case .invalidHeader(let x1):
				return invalidHeader(x1)
			case .noValueAtPath(let x1):
				return noValueAtPath(x1)
			case .noValueInArray(let x1):
				return noValueInArray(x1)
			case .noResults:
				return noResults()
			case .invalidData(let x1):
				return invalidData(x1)
			case .errorMessage(let x1):
				return errorMessage(x1)
			case .errorMessages(let x1):
				return errorMessages(x1)
			case .errorPlist(let x1):
				return errorPlist(x1)
			case .unauthorized:
				return unauthorized()
			case .serialization(let x1):
				return serialization(x1)
			case .deserialization(let x1):
				return deserialization(x1)
			case .undefined(let x1):
				return undefined(x1)
		}
	}

	func match_generic<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: (NSError) -> ReturnedType) -> ReturnedType {
		if case .generic(let x1) = self {
			return matchFunction(x1)
		} else {
			return fallback()
		}
	}

	func isCase_generic(_ isCaseFunction: (NSError) -> Bool = { _ in true }) -> Bool {
		if case .generic(let x1) = self {
			return isCaseFunction(x1)
		} else {
			return false
		}
	}

	func match_connection<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: (NSError) -> ReturnedType) -> ReturnedType {
		if case .connection(let x1) = self {
			return matchFunction(x1)
		} else {
			return fallback()
		}
	}

	func isCase_connection(_ isCaseFunction: (NSError) -> Bool = { _ in true }) -> Bool {
		if case .connection(let x1) = self {
			return isCaseFunction(x1)
		} else {
			return false
		}
	}

	func match_request<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: (URLComponents) -> ReturnedType) -> ReturnedType {
		if case .request(let x1) = self {
			return matchFunction(x1)
		} else {
			return fallback()
		}
	}

	func isCase_request(_ isCaseFunction: (URLComponents) -> Bool = { _ in true }) -> Bool {
		if case .request(let x1) = self {
			return isCaseFunction(x1)
		} else {
			return false
		}
	}

	func match_noData<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: () -> ReturnedType) -> ReturnedType {
		if case .noData = self {
			return matchFunction()
		} else {
			return fallback()
		}
	}

	func isCase_noData(_ isCaseFunction: () -> Bool = {  true }) -> Bool {
		if case .noData = self {
			return isCaseFunction()
		} else {
			return false
		}
	}

	func match_noResponse<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: () -> ReturnedType) -> ReturnedType {
		if case .noResponse = self {
			return matchFunction()
		} else {
			return fallback()
		}
	}

	func isCase_noResponse(_ isCaseFunction: () -> Bool = {  true }) -> Bool {
		if case .noResponse = self {
			return isCaseFunction()
		} else {
			return false
		}
	}

	func match_invalidHTTPCode<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: (Int) -> ReturnedType) -> ReturnedType {
		if case .invalidHTTPCode(let x1) = self {
			return matchFunction(x1)
		} else {
			return fallback()
		}
	}

	func isCase_invalidHTTPCode(_ isCaseFunction: (Int) -> Bool = { _ in true }) -> Bool {
		if case .invalidHTTPCode(let x1) = self {
			return isCaseFunction(x1)
		} else {
			return false
		}
	}

	func match_invalidHeader<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: (String) -> ReturnedType) -> ReturnedType {
		if case .invalidHeader(let x1) = self {
			return matchFunction(x1)
		} else {
			return fallback()
		}
	}

	func isCase_invalidHeader(_ isCaseFunction: (String) -> Bool = { _ in true }) -> Bool {
		if case .invalidHeader(let x1) = self {
			return isCaseFunction(x1)
		} else {
			return false
		}
	}

	func match_noValueAtPath<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: (PathError) -> ReturnedType) -> ReturnedType {
		if case .noValueAtPath(let x1) = self {
			return matchFunction(x1)
		} else {
			return fallback()
		}
	}

	func isCase_noValueAtPath(_ isCaseFunction: (PathError) -> Bool = { _ in true }) -> Bool {
		if case .noValueAtPath(let x1) = self {
			return isCaseFunction(x1)
		} else {
			return false
		}
	}

	func match_noValueInArray<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: (Int) -> ReturnedType) -> ReturnedType {
		if case .noValueInArray(let x1) = self {
			return matchFunction(x1)
		} else {
			return fallback()
		}
	}

	func isCase_noValueInArray(_ isCaseFunction: (Int) -> Bool = { _ in true }) -> Bool {
		if case .noValueInArray(let x1) = self {
			return isCaseFunction(x1)
		} else {
			return false
		}
	}

	func match_noResults<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: () -> ReturnedType) -> ReturnedType {
		if case .noResults = self {
			return matchFunction()
		} else {
			return fallback()
		}
	}

	func isCase_noResults(_ isCaseFunction: () -> Bool = {  true }) -> Bool {
		if case .noResults = self {
			return isCaseFunction()
		} else {
			return false
		}
	}

	func match_invalidData<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: (String) -> ReturnedType) -> ReturnedType {
		if case .invalidData(let x1) = self {
			return matchFunction(x1)
		} else {
			return fallback()
		}
	}

	func isCase_invalidData(_ isCaseFunction: (String) -> Bool = { _ in true }) -> Bool {
		if case .invalidData(let x1) = self {
			return isCaseFunction(x1)
		} else {
			return false
		}
	}

	func match_errorMessage<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: (String) -> ReturnedType) -> ReturnedType {
		if case .errorMessage(let x1) = self {
			return matchFunction(x1)
		} else {
			return fallback()
		}
	}

	func isCase_errorMessage(_ isCaseFunction: (String) -> Bool = { _ in true }) -> Bool {
		if case .errorMessage(let x1) = self {
			return isCaseFunction(x1)
		} else {
			return false
		}
	}

	func match_errorMessages<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: ([String]) -> ReturnedType) -> ReturnedType {
		if case .errorMessages(let x1) = self {
			return matchFunction(x1)
		} else {
			return fallback()
		}
	}

	func isCase_errorMessages(_ isCaseFunction: ([String]) -> Bool = { _ in true }) -> Bool {
		if case .errorMessages(let x1) = self {
			return isCaseFunction(x1)
		} else {
			return false
		}
	}

	func match_errorPlist<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: ([String: Any]) -> ReturnedType) -> ReturnedType {
		if case .errorPlist(let x1) = self {
			return matchFunction(x1)
		} else {
			return fallback()
		}
	}

	func isCase_errorPlist(_ isCaseFunction: ([String: Any]) -> Bool = { _ in true }) -> Bool {
		if case .errorPlist(let x1) = self {
			return isCaseFunction(x1)
		} else {
			return false
		}
	}

	func match_unauthorized<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: () -> ReturnedType) -> ReturnedType {
		if case .unauthorized = self {
			return matchFunction()
		} else {
			return fallback()
		}
	}

	func isCase_unauthorized(_ isCaseFunction: () -> Bool = {  true }) -> Bool {
		if case .unauthorized = self {
			return isCaseFunction()
		} else {
			return false
		}
	}

	func match_serialization<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: (SerializationError) -> ReturnedType) -> ReturnedType {
		if case .serialization(let x1) = self {
			return matchFunction(x1)
		} else {
			return fallback()
		}
	}

	func isCase_serialization(_ isCaseFunction: (SerializationError) -> Bool = { _ in true }) -> Bool {
		if case .serialization(let x1) = self {
			return isCaseFunction(x1)
		} else {
			return false
		}
	}

	func match_deserialization<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: (DeserializationError) -> ReturnedType) -> ReturnedType {
		if case .deserialization(let x1) = self {
			return matchFunction(x1)
		} else {
			return fallback()
		}
	}

	func isCase_deserialization(_ isCaseFunction: (DeserializationError) -> Bool = { _ in true }) -> Bool {
		if case .deserialization(let x1) = self {
			return isCaseFunction(x1)
		} else {
			return false
		}
	}

	func match_undefined<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: (Error) -> ReturnedType) -> ReturnedType {
		if case .undefined(let x1) = self {
			return matchFunction(x1)
		} else {
			return fallback()
		}
	}

	func isCase_undefined(_ isCaseFunction: (Error) -> Bool = { _ in true }) -> Bool {
		if case .undefined(let x1) = self {
			return isCaseFunction(x1)
		} else {
			return false
		}
	}

}


public extension HTTPMethod {
	func match<ReturnedType>(
		get: () -> ReturnedType, 
		post: () -> ReturnedType, 
		put: () -> ReturnedType, 
		patch: () -> ReturnedType, 
		delete: () -> ReturnedType
		) -> ReturnedType {
		switch self {
			case .get:
				return get()
			case .post:
				return post()
			case .put:
				return put()
			case .patch:
				return patch()
			case .delete:
				return delete()
		}
	}

	func match_get<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: () -> ReturnedType) -> ReturnedType {
		if case .get = self {
			return matchFunction()
		} else {
			return fallback()
		}
	}

	func isCase_get(_ isCaseFunction: () -> Bool = {  true }) -> Bool {
		if case .get = self {
			return isCaseFunction()
		} else {
			return false
		}
	}

	func match_post<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: () -> ReturnedType) -> ReturnedType {
		if case .post = self {
			return matchFunction()
		} else {
			return fallback()
		}
	}

	func isCase_post(_ isCaseFunction: () -> Bool = {  true }) -> Bool {
		if case .post = self {
			return isCaseFunction()
		} else {
			return false
		}
	}

	func match_put<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: () -> ReturnedType) -> ReturnedType {
		if case .put = self {
			return matchFunction()
		} else {
			return fallback()
		}
	}

	func isCase_put(_ isCaseFunction: () -> Bool = {  true }) -> Bool {
		if case .put = self {
			return isCaseFunction()
		} else {
			return false
		}
	}

	func match_patch<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: () -> ReturnedType) -> ReturnedType {
		if case .patch = self {
			return matchFunction()
		} else {
			return fallback()
		}
	}

	func isCase_patch(_ isCaseFunction: () -> Bool = {  true }) -> Bool {
		if case .patch = self {
			return isCaseFunction()
		} else {
			return false
		}
	}

	func match_delete<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: () -> ReturnedType) -> ReturnedType {
		if case .delete = self {
			return matchFunction()
		} else {
			return fallback()
		}
	}

	func isCase_delete(_ isCaseFunction: () -> Bool = {  true }) -> Bool {
		if case .delete = self {
			return isCaseFunction()
		} else {
			return false
		}
	}

}


public extension JSONError {
	func match<ReturnedType>(
		serialization: (NSError) -> ReturnedType, 
		invalidTopLevelObject: () -> ReturnedType, 
		nonJSONType: () -> ReturnedType
		) -> ReturnedType {
		switch self {
			case .serialization(let x1):
				return serialization(x1)
			case .invalidTopLevelObject:
				return invalidTopLevelObject()
			case .nonJSONType:
				return nonJSONType()
		}
	}

	func match_serialization<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: (NSError) -> ReturnedType) -> ReturnedType {
		if case .serialization(let x1) = self {
			return matchFunction(x1)
		} else {
			return fallback()
		}
	}

	func isCase_serialization(_ isCaseFunction: (NSError) -> Bool = { _ in true }) -> Bool {
		if case .serialization(let x1) = self {
			return isCaseFunction(x1)
		} else {
			return false
		}
	}

	func match_invalidTopLevelObject<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: () -> ReturnedType) -> ReturnedType {
		if case .invalidTopLevelObject = self {
			return matchFunction()
		} else {
			return fallback()
		}
	}

	func isCase_invalidTopLevelObject(_ isCaseFunction: () -> Bool = {  true }) -> Bool {
		if case .invalidTopLevelObject = self {
			return isCaseFunction()
		} else {
			return false
		}
	}

	func match_nonJSONType<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: () -> ReturnedType) -> ReturnedType {
		if case .nonJSONType = self {
			return matchFunction()
		} else {
			return fallback()
		}
	}

	func isCase_nonJSONType(_ isCaseFunction: () -> Bool = {  true }) -> Bool {
		if case .nonJSONType = self {
			return isCaseFunction()
		} else {
			return false
		}
	}

}


public extension JSONObject {
	func match<ReturnedType>(
		null: () -> ReturnedType, 
		number: (JSONNumber) -> ReturnedType, 
		bool: (Bool) -> ReturnedType, 
		string: (String) -> ReturnedType, 
		array: ([JSONObject]) -> ReturnedType, 
		dict: ([String: JSONObject]) -> ReturnedType
		) -> ReturnedType {
		switch self {
			case .null:
				return null()
			case .number(let x1):
				return number(x1)
			case .bool(let x1):
				return bool(x1)
			case .string(let x1):
				return string(x1)
			case .array(let x1):
				return array(x1)
			case .dict(let x1):
				return dict(x1)
		}
	}

	func match_null<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: () -> ReturnedType) -> ReturnedType {
		if case .null = self {
			return matchFunction()
		} else {
			return fallback()
		}
	}

	func isCase_null(_ isCaseFunction: () -> Bool = {  true }) -> Bool {
		if case .null = self {
			return isCaseFunction()
		} else {
			return false
		}
	}

	func match_number<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: (JSONNumber) -> ReturnedType) -> ReturnedType {
		if case .number(let x1) = self {
			return matchFunction(x1)
		} else {
			return fallback()
		}
	}

	func isCase_number(_ isCaseFunction: (JSONNumber) -> Bool = { _ in true }) -> Bool {
		if case .number(let x1) = self {
			return isCaseFunction(x1)
		} else {
			return false
		}
	}

	func match_bool<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: (Bool) -> ReturnedType) -> ReturnedType {
		if case .bool(let x1) = self {
			return matchFunction(x1)
		} else {
			return fallback()
		}
	}

	func isCase_bool(_ isCaseFunction: (Bool) -> Bool = { _ in true }) -> Bool {
		if case .bool(let x1) = self {
			return isCaseFunction(x1)
		} else {
			return false
		}
	}

	func match_string<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: (String) -> ReturnedType) -> ReturnedType {
		if case .string(let x1) = self {
			return matchFunction(x1)
		} else {
			return fallback()
		}
	}

	func isCase_string(_ isCaseFunction: (String) -> Bool = { _ in true }) -> Bool {
		if case .string(let x1) = self {
			return isCaseFunction(x1)
		} else {
			return false
		}
	}

	func match_array<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: ([JSONObject]) -> ReturnedType) -> ReturnedType {
		if case .array(let x1) = self {
			return matchFunction(x1)
		} else {
			return fallback()
		}
	}

	func isCase_array(_ isCaseFunction: ([JSONObject]) -> Bool = { _ in true }) -> Bool {
		if case .array(let x1) = self {
			return isCaseFunction(x1)
		} else {
			return false
		}
	}

	func match_dict<ReturnedType>(or fallback: @autoclosure () -> ReturnedType, _ matchFunction: ([String: JSONObject]) -> ReturnedType) -> ReturnedType {
		if case .dict(let x1) = self {
			return matchFunction(x1)
		} else {
			return fallback()
		}
	}

	func isCase_dict(_ isCaseFunction: ([String: JSONObject]) -> Bool = { _ in true }) -> Bool {
		if case .dict(let x1) = self {
			return isCaseFunction(x1)
		} else {
			return false
		}
	}

}

