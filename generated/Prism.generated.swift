// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT



import Foundation
import FunctionalKit



extension ClientError {
    public enum prism {
        public static let generic = Prism<ClientError,NSError>(
            tryGet: { if case .generic(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .generic(x1) })

        public static let connection = Prism<ClientError,NSError>(
            tryGet: { if case .connection(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .connection(x1) })

        public static let request = Prism<ClientError,URLComponents>(
            tryGet: { if case .request(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .request(x1) })

        public static let noData = Prism<ClientError, ()>(
            tryGet: { if case .noData = $0 { return () } else { return nil } },
            inject: { .noData })

        public static let noResponse = Prism<ClientError, ()>(
            tryGet: { if case .noResponse = $0 { return () } else { return nil } },
            inject: { .noResponse })

        public static let invalidHTTPCode = Prism<ClientError,Int>(
            tryGet: { if case .invalidHTTPCode(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .invalidHTTPCode(x1) })

        public static let invalidHeader = Prism<ClientError,String>(
            tryGet: { if case .invalidHeader(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .invalidHeader(x1) })

        public static let noValueAtPath = Prism<ClientError,PathError>(
            tryGet: { if case .noValueAtPath(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .noValueAtPath(x1) })

        public static let noValueInArray = Prism<ClientError,Int>(
            tryGet: { if case .noValueInArray(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .noValueInArray(index:x1) })

        public static let noResults = Prism<ClientError, ()>(
            tryGet: { if case .noResults = $0 { return () } else { return nil } },
            inject: { .noResults })

        public static let invalidData = Prism<ClientError,String>(
            tryGet: { if case .invalidData(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .invalidData(x1) })

        public static let errorMessage = Prism<ClientError,String>(
            tryGet: { if case .errorMessage(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .errorMessage(x1) })

        public static let errorMessages = Prism<ClientError,[String]>(
            tryGet: { if case .errorMessages(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .errorMessages(x1) })

        public static let errorPlist = Prism<ClientError,[String: Any]>(
            tryGet: { if case .errorPlist(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .errorPlist(x1) })

        public static let unauthorized = Prism<ClientError, ()>(
            tryGet: { if case .unauthorized = $0 { return () } else { return nil } },
            inject: { .unauthorized })

        public static let serialization = Prism<ClientError,SerializationError>(
            tryGet: { if case .serialization(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .serialization(x1) })

        public static let deserialization = Prism<ClientError,DeserializationError>(
            tryGet: { if case .deserialization(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .deserialization(x1) })

        public static let undefined = Prism<ClientError,Error>(
            tryGet: { if case .undefined(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .undefined(x1) })

    }
}



extension DeserializationError {
    public enum prism {
        public static let toAny = Prism<DeserializationError,NSError?>(
            tryGet: { if case .toAny(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .toAny(x1) })

        public static let toAnyDict = Prism<DeserializationError,NSError?>(
            tryGet: { if case .toAnyDict(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .toAnyDict(x1) })

        public static let toArray = Prism<DeserializationError,NSError?>(
            tryGet: { if case .toArray(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .toArray(x1) })

        public static let toString = Prism<DeserializationError, ()>(
            tryGet: { if case .toString = $0 { return () } else { return nil } },
            inject: { .toString })

    }
}



extension HTTPMethod {
    public enum prism {
        public static let get = Prism<HTTPMethod, ()>(
            tryGet: { if case .get = $0 { return () } else { return nil } },
            inject: { .get })

        public static let post = Prism<HTTPMethod, ()>(
            tryGet: { if case .post = $0 { return () } else { return nil } },
            inject: { .post })

        public static let put = Prism<HTTPMethod, ()>(
            tryGet: { if case .put = $0 { return () } else { return nil } },
            inject: { .put })

        public static let patch = Prism<HTTPMethod, ()>(
            tryGet: { if case .patch = $0 { return () } else { return nil } },
            inject: { .patch })

        public static let delete = Prism<HTTPMethod, ()>(
            tryGet: { if case .delete = $0 { return () } else { return nil } },
            inject: { .delete })

    }
}



extension JSONError {
    public enum prism {
        public static let serialization = Prism<JSONError,NSError>(
            tryGet: { if case .serialization(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .serialization(x1) })

        public static let invalidTopLevelObject = Prism<JSONError, ()>(
            tryGet: { if case .invalidTopLevelObject = $0 { return () } else { return nil } },
            inject: { .invalidTopLevelObject })

        public static let nonJSONType = Prism<JSONError, ()>(
            tryGet: { if case .nonJSONType = $0 { return () } else { return nil } },
            inject: { .nonJSONType })

    }
}



extension JSONObject {
    public enum prism {
        public static let null = Prism<JSONObject, ()>(
            tryGet: { if case .null = $0 { return () } else { return nil } },
            inject: { .null })

        public static let number = Prism<JSONObject,JSONNumber>(
            tryGet: { if case .number(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .number(x1) })

        public static let bool = Prism<JSONObject,Bool>(
            tryGet: { if case .bool(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .bool(x1) })

        public static let string = Prism<JSONObject,String>(
            tryGet: { if case .string(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .string(x1) })

        public static let array = Prism<JSONObject,[JSONObject]>(
            tryGet: { if case .array(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .array(x1) })

        public static let dict = Prism<JSONObject,[String: JSONObject]>(
            tryGet: { if case .dict(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .dict(x1) })

    }
}



extension Multipart.Part {
    public enum prism {
        public static let text = Prism<Multipart.Part,Multipart.Part.Text>(
            tryGet: { if case .text(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .text(x1) })

        public static let file = Prism<Multipart.Part,Multipart.Part.File>(
            tryGet: { if case .file(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .file(x1) })

    }
}



extension PathError {
    public enum prism {
        public static let emptyPath = Prism<PathError,([String: Any], Path)>(
            tryGet: { if case .emptyPath(let value) = $0 { return value } else { return nil } },
            inject: { (x1, x2) in .emptyPath(root:x1, path:x2) })

        public static let noDictAtKey = Prism<PathError,([String: Any], Path, String)>(
            tryGet: { if case .noDictAtKey(let value) = $0 { return value } else { return nil } },
            inject: { (x1, x2, x3) in .noDictAtKey(root:x1, path:x2, key:x3) })

        public static let noTargetForLastKey = Prism<PathError,([String: Any], Path, String)>(
            tryGet: { if case .noTargetForLastKey(let value) = $0 { return value } else { return nil } },
            inject: { (x1, x2, x3) in .noTargetForLastKey(root:x1, path:x2, key:x3) })

        public static let wrongTargetTypeForLastKey = Prism<PathError,([String: Any], Path, String)>(
            tryGet: { if case .wrongTargetTypeForLastKey(let value) = $0 { return value } else { return nil } },
            inject: { (x1, x2, x3) in .wrongTargetTypeForLastKey(root:x1, path:x2, typeDescription:x3) })

        public static let wrongTargetContentForLastKey = Prism<PathError,([String: Any], Path, String)>(
            tryGet: { if case .wrongTargetContentForLastKey(let value) = $0 { return value } else { return nil } },
            inject: { (x1, x2, x3) in .wrongTargetContentForLastKey(root:x1, path:x2, contentDescription:x3) })

        public static let multiple = Prism<PathError,[PathError]>(
            tryGet: { if case .multiple(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .multiple(x1) })

    }
}



extension SerializationError {
    public enum prism {
        public static let toJSON = Prism<SerializationError, ()>(
            tryGet: { if case .toJSON = $0 { return () } else { return nil } },
            inject: { .toJSON })

        public static let toFormURLEncoded = Prism<SerializationError, ()>(
            tryGet: { if case .toFormURLEncoded = $0 { return () } else { return nil } },
            inject: { .toFormURLEncoded })

    }
}


