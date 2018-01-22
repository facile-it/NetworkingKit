import Foundation

public struct Multipart: Equatable {
	public static let errorDomain = "Client.Multipart"
	static let newLineString = "\r\n"
	static let newLineData = newLineString.data(using: .utf8)!
	static let preBoundaryString = "--"

	var boundary: String
	var contentBoundary: String
	var contentBoundaryData: Data
	var parts: [Part]
	private init(boundary: String, contentBoundary: String, contentBoundaryData: Data, parts: [Part]) {
		self.boundary = boundary
		self.contentBoundary = contentBoundary
		self.contentBoundaryData = contentBoundaryData
		self.parts = parts
	}

	public init(boundary: String, parts: [Part] = []) {
		let contentBoundary = Multipart.preBoundaryString + boundary
		self.init(
			boundary: boundary,
			contentBoundary: contentBoundary,
			contentBoundaryData: contentBoundary.data(using: .utf8)!,
			parts: parts)
	}

	public func adding(part: Part) -> Multipart {
		return Multipart(
			boundary: boundary,
			contentBoundary: contentBoundary,
			contentBoundaryData: contentBoundaryData,
			parts: parts + [part])
	}

	public var headers: [String:String] {
		return ["Content-Type" : "multipart/form-data; boundary=\(boundary)"]
	}

	public var inspect: (boundary: String, parts: [Part]) {
		return (boundary: boundary, parts: parts)
	}

	public var stringRepresentation: String {
		guard parts.count > 0 else { return "" }

		let elements = [contentBoundary] + parts.map { Multipart.newLineString + $0.stringRepresentation + Multipart.newLineString + self.contentBoundary }
		return elements.reduce("", +)
	}

	public func getData() throws -> Data {
		guard parts.count > 0 else { return Data() }

		let elements = [contentBoundaryData] + (try parts.map {
			Multipart.newLineData
				+ (try $0.getData())
				+ Multipart.newLineData
				+ self.contentBoundaryData })
		return elements.reduce(Data()) { var m_data = $0; m_data.append($1); return m_data }
	}

	public static func == (left: Multipart, right: Multipart) -> Bool {
		return left.boundary == right.boundary
			&& left.contentBoundary == right.contentBoundary
			&& left.contentBoundaryData == right.contentBoundaryData
			&& left.parts == right.parts
	}

	public enum Part: Equatable {
		case text(Text)
		case file(File)

		public var stringRepresentation: String {
			switch self {
			case .text(let value):
				return value.stringRepresentation
			case .file(let value):
				return value.stringRepresentation
			}
		}

		public func getData() throws -> Data {
			switch self {
			case .text(let value):
				return try value.getData()
			case .file(let value):
				return try value.getData()
			}
		}

		public static func == (left: Part, right: Part) -> Bool {
			switch (left,right) {
			case (.text(let leftValue), .text(let rightValue)):
				return leftValue == rightValue
			case (.file(let leftValue), .file(let rightValue)):
				return leftValue == rightValue
			default:
				return false
			}
		}

		public struct Text: Equatable {
			public var name: String
			public var content: String

			public init(name: String, content: String) {
				self.name = name
				self.content = content
			}

			public var stringRepresentation: String {
				return headerDataString + content
			}

			public func getData() throws -> Data {
				let fullDataString = headerDataString + content
				guard let fullData = fullDataString.data(using: .utf8) else {
					throw NSError(
						domain: Multipart.errorDomain,
						code: 1,
						userInfo: [NSLocalizedDescriptionKey : "Cannot generate Text full data from \(self)"])
				}
				return fullData
			}

			private var headerDataString: String {
				return "Content-Disposition: form-data; name=\"\(name)\""
					+ Multipart.newLineString
					+ Multipart.newLineString
			}

			public static func == (left: Text, right: Text) -> Bool {
				return left.name == right.name
					&& left.content == right.content
			}
		}

		public struct File: Equatable {
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

			public var stringRepresentation: String {
				return headerDataString + "Data with byte count: \(data.count)"
			}

			public func getData() throws -> Data {
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

			private var headerDataString: String {
				return "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\""
					+ Multipart.newLineString
					+ "Content-Type: \(contentType)"
					+ Multipart.newLineString
					+ Multipart.newLineString
			}

			public static func == (left: File, right: File) -> Bool {
				return left.contentType == right.contentType
					&& left.name == right.name
					&& left.filename == right.filename
					&& left.data == right.data
			}
		}
	}
}
