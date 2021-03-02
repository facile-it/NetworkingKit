// Generated using Sourcery 1.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT



// MARK: - Equatable for structs and classes

extension ConnectionConfiguration: Equatable {
    public  static func == (lhs: ConnectionConfiguration, rhs: ConnectionConfiguration) -> Bool {
		guard lhs.scheme == rhs.scheme else { return false }
		guard lhs.host == rhs.host else { return false }
		guard lhs.port == rhs.port else { return false }
		guard lhs.rootPath == rhs.rootPath else { return false }
		guard lhs.defaultHeaders == rhs.defaultHeaders else { return false }
        return true
    }
}

extension ConnectionInfo: Equatable {
    public  static func == (lhs: ConnectionInfo, rhs: ConnectionInfo) -> Bool {
		guard lhs.connectionName == rhs.connectionName else { return false }
		guard lhs.request == rhs.request else { return false }
		guard lhs.response == rhs.response else { return false }
        return true
    }
}

extension ConnectionInfo.Request: Equatable {
    public  static func == (lhs: ConnectionInfo.Request, rhs: ConnectionInfo.Request) -> Bool {
		guard lhs.urlComponents == rhs.urlComponents else { return false }
		guard lhs.originalRequest == rhs.originalRequest else { return false }
		guard lhs.bodyStringRepresentation == rhs.bodyStringRepresentation else { return false }
        return true
    }
}

extension ConnectionInfo.Response: Equatable {
    public  static func == (lhs: ConnectionInfo.Response, rhs: ConnectionInfo.Response) -> Bool {
		guard lhs.connectionError == rhs.connectionError else { return false }
		guard lhs.serverResponse == rhs.serverResponse else { return false }
		guard lhs.serverOutput == rhs.serverOutput else { return false }
		guard lhs.downloadedFileURL == rhs.downloadedFileURL else { return false }
        return true
    }
}

extension HTTPRequest: Equatable {
    public  static func == (lhs: HTTPRequest, rhs: HTTPRequest) -> Bool {
		guard lhs.identifier == rhs.identifier else { return false }
		guard lhs.urlComponents == rhs.urlComponents else { return false }
		guard lhs.method == rhs.method else { return false }
		guard lhs.headers == rhs.headers else { return false }
		guard lhs.body == rhs.body else { return false }
        return true
    }
}

extension Multipart: Equatable {
    public  static func == (lhs: Multipart, rhs: Multipart) -> Bool {
		guard lhs.boundary == rhs.boundary else { return false }
		guard lhs.contentBoundary == rhs.contentBoundary else { return false }
		guard lhs.lastContentBoundary == rhs.lastContentBoundary else { return false }
		guard lhs.contentBoundaryData == rhs.contentBoundaryData else { return false }
		guard lhs.lastContentBoundaryData == rhs.lastContentBoundaryData else { return false }
		guard lhs.parts == rhs.parts else { return false }
        return true
    }
}

extension Multipart.Part.File: Equatable {
    public  static func == (lhs: Multipart.Part.File, rhs: Multipart.Part.File) -> Bool {
		guard lhs.contentType == rhs.contentType else { return false }
		guard lhs.name == rhs.name else { return false }
		guard lhs.filename == rhs.filename else { return false }
		guard lhs.data == rhs.data else { return false }
        return true
    }
}

extension Multipart.Part.Text: Equatable {
    public  static func == (lhs: Multipart.Part.Text, rhs: Multipart.Part.Text) -> Bool {
		guard lhs.name == rhs.name else { return false }
		guard lhs.content == rhs.content else { return false }
        return true
    }
}

// MARK: - Equatable for enums

extension JSONError: Equatable {
    public static func == (lhs: JSONError, rhs: JSONError) -> Bool {
        switch (lhs,rhs) {
            case (.serialization(let lhs), .serialization(let rhs)):
				return lhs == rhs
            case (.invalidTopLevelObject, .invalidTopLevelObject):
                return true
            case (.nonJSONType, .nonJSONType):
                return true
			default: return false
        }
    }
}

extension Multipart.Part: Equatable {
    public static func == (lhs: Multipart.Part, rhs: Multipart.Part) -> Bool {
        switch (lhs,rhs) {
            case (.text(let lhs), .text(let rhs)):
				return lhs == rhs
            case (.file(let lhs), .file(let rhs)):
				return lhs == rhs
			default: return false
        }
    }
}
