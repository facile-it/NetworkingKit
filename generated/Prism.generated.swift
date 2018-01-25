// Generated using Sourcery 0.7.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Abstract
import FunctionalKit
import Optics


extension JSONError {
    enum prism {
        static let serialization = Prism<JSONError,NSError>(
            tryGet: { if case .serialization(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .serialization(x1) })
        static let invalidTopLevelObject = Prism<JSONError, ()>(
            tryGet: { if case .invalidTopLevelObject = $0 { return () } else { return nil } },
            inject: { .invalidTopLevelObject })
        static let nonJSONType = Prism<JSONError, ()>(
            tryGet: { if case .nonJSONType = $0 { return () } else { return nil } },
            inject: { .nonJSONType })
    }
}

extension JSONObject {
    enum prism {
        static let null = Prism<JSONObject, ()>(
            tryGet: { if case .null = $0 { return () } else { return nil } },
            inject: { .null })
        static let number = Prism<JSONObject,JSONNumber>(
            tryGet: { if case .number(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .number(x1) })
        static let bool = Prism<JSONObject,Bool>(
            tryGet: { if case .bool(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .bool(x1) })
        static let string = Prism<JSONObject,String>(
            tryGet: { if case .string(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .string(x1) })
        static let array = Prism<JSONObject,[JSONObject]>(
            tryGet: { if case .array(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .array(x1) })
        static let dict = Prism<JSONObject,[String: JSONObject]>(
            tryGet: { if case .dict(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .dict(x1) })
    }
}

extension PathError {
    enum prism {
        static let emptyPath = Prism<PathError,([String: Any], Path)>(
            tryGet: { if case .emptyPath(let value) = $0 { return value } else { return nil } },
            inject: { (x1, x2) in .emptyPath(root:x1, path:x2) })
        static let noDictAtKey = Prism<PathError,([String: Any], Path, String)>(
            tryGet: { if case .noDictAtKey(let value) = $0 { return value } else { return nil } },
            inject: { (x1, x2, x3) in .noDictAtKey(root:x1, path:x2, key:x3) })
        static let noTargetForLastKey = Prism<PathError,([String: Any], Path, String)>(
            tryGet: { if case .noTargetForLastKey(let value) = $0 { return value } else { return nil } },
            inject: { (x1, x2, x3) in .noTargetForLastKey(root:x1, path:x2, key:x3) })
        static let wrongTargetTypeForLastKey = Prism<PathError,([String: Any], Path, String)>(
            tryGet: { if case .wrongTargetTypeForLastKey(let value) = $0 { return value } else { return nil } },
            inject: { (x1, x2, x3) in .wrongTargetTypeForLastKey(root:x1, path:x2, typeDescription:x3) })
        static let wrongTargetContentForLastKey = Prism<PathError,([String: Any], Path, String)>(
            tryGet: { if case .wrongTargetContentForLastKey(let value) = $0 { return value } else { return nil } },
            inject: { (x1, x2, x3) in .wrongTargetContentForLastKey(root:x1, path:x2, contentDescription:x3) })
        static let multiple = Prism<PathError,[PathError]>(
            tryGet: { if case .multiple(let value) = $0 { return value } else { return nil } },
            inject: { (x1) in .multiple(x1) })
    }
}
