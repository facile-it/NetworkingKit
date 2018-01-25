// Generated using Sourcery 0.7.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Abstract
import FunctionalKit
import Optics


extension JSONError {
    enum prism {
        static let serialization = Prism<JSONError,NSError>(
            tryGet: { if case .serialization(let value) = $0 { return value } else { return nil } },
            inject: { .serialization($0) })
        static let invalidTopLevelObject = Prism<JSONError, ()>(
            tryGet: { if case .invalidTopLevelObject = $0 { return () } else { return nil } },
            inject: { .invalidTopLevelObject })
        static let nonJSONType = Prism<JSONError, ()>(
            tryGet: { if case .nonJSONType = $0 { return () } else { return nil } },
            inject: { .nonJSONType })
    }
}
