import Foundation

// sourcery: equatable
// sourcery: lens
public struct Multipart {
	public static let errorDomain = "Client.Multipart"
	public static let newLineString = "\r\n"
	public static let newLineData = newLineString.data(using: .utf8)!
	public static let preBoundaryString = "--"
    public static let postBoundaryString = "--"

	var boundary: String
	var contentBoundary: String
    var lastContentBoundary: String
	var contentBoundaryData: Data
    var lastContentBoundaryData: Data
	var parts: [Part]

	// sourcery:inline:Multipart.Init
    public init(boundary: String, contentBoundary: String, lastContentBoundary: String, contentBoundaryData: Data, lastContentBoundaryData: Data, parts: [Multipart.Part]) {
        self.boundary = boundary
        self.contentBoundary = contentBoundary
        self.lastContentBoundary = lastContentBoundary
        self.contentBoundaryData = contentBoundaryData
        self.lastContentBoundaryData = lastContentBoundaryData
        self.parts = parts
    }
	// sourcery:end

	public init(boundary: String, parts: [Part] = []) {
		let contentBoundary = Multipart.preBoundaryString + boundary
        let lastContentBoundary = contentBoundary + Multipart.postBoundaryString
		self.init(
			boundary: boundary,
			contentBoundary: contentBoundary,
            lastContentBoundary: lastContentBoundary,
			contentBoundaryData: contentBoundary.data(using: .utf8)!,
            lastContentBoundaryData: lastContentBoundary.data(using: .utf8)!,
			parts: parts)
	}

	// sourcery: equatable
    // sourcery: prism
	public enum Part {
		case text(Text)
		case file(File)

		// sourcery: equatable
		// sourcery: lens
		public struct Text {
			public var name: String
			public var content: String

			public init(name: String, content: String) {
				self.name = name
				self.content = content
			}
		}

		// sourcery: equatable
        // sourcery: lens
		public struct File {
			public var contentType: String
			public var name: String
			public var filename: String
			public var data: Data

			public init(contentType: String, name: String, filename: String, data: Data) {
				self.contentType = contentType
				self.name = name
				self.filename = filename
				self.data = data
			}
		}
	}
}

// MARK: - Public

public extension Multipart {
	var headers: [String:String] {
		return ["Content-Type" : "multipart/form-data; boundary=\(boundary)"]
	}

	var inspect: (boundary: String, parts: [Part]) {
		return (boundary: boundary, parts: parts)
	}

	var stringRepresentation: String {
		guard parts.isEmpty.not else { return "" }

        let elements = parts
            .map {
                contentBoundary + Multipart.newLineString + $0.stringRepresentation + Multipart.newLineString
            }
            .appending(lastContentBoundary)

		return elements.reduce("", +)
	}

	func adding(part: Part) -> Multipart {
		return Multipart.init(
			boundary: boundary,
			contentBoundary: contentBoundary,
            lastContentBoundary: lastContentBoundary,
			contentBoundaryData: contentBoundaryData,
            lastContentBoundaryData: lastContentBoundaryData,
			parts: parts + [part])
	}

	func getData() throws -> Data {
		guard parts.count > 0 else { return Data() }

        let elements = try parts
            .map {
                contentBoundaryData
                    + Multipart.newLineData
                    + (try $0.getData())
                    + Multipart.newLineData
            }
            .appending(lastContentBoundaryData)

		return elements.reduce(Data()) { var m_data = $0; m_data.append($1); return m_data }
	}
}

public extension Multipart.Part {
	var stringRepresentation: String {
		switch self {
		case .text(let value):
			return value.stringRepresentation
		case .file(let value):
			return value.stringRepresentation
		}
	}

	func getData() throws -> Data {
		switch self {
		case .text(let value):
			return try value.getData()
		case .file(let value):
			return try value.getData()
		}
	}
}

public extension Multipart.Part.Text {
	var stringRepresentation: String {
		return headerDataString + content
	}

	var headerDataString: String {
		return "Content-Disposition: form-data; name=\"\(name)\""
			+ Multipart.newLineString
			+ Multipart.newLineString
	}

	func getData() throws -> Data {
		let fullDataString = headerDataString + content
		guard let fullData = fullDataString.data(using: .utf8) else {
			throw NSError(
				domain: Multipart.errorDomain,
				code: 1,
				userInfo: [NSLocalizedDescriptionKey : "Cannot generate Text full data from \(self)"])
		}
		return fullData
	}
}

public extension Multipart.Part.File {
	var stringRepresentation: String {
		return headerDataString + "Data with byte count: \(data.count)"
	}

	var headerDataString: String {
		return "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\""
			+ Multipart.newLineString
			+ "Content-Type: \(contentType)"
			+ Multipart.newLineString
			+ Multipart.newLineString
	}

	func getData() throws -> Data {
		guard
			let headerData = headerDataString.data(using: .utf8) else {
				throw NSError(
					domain: Multipart.errorDomain,
					code: 2,
					userInfo: [NSLocalizedDescriptionKey : "Cannot generate File header data from \(self)"])
		}
		var fullData = headerData
		fullData.append(data)
		return fullData
	}
}
