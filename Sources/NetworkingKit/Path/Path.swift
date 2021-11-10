import Foundation
import Abstract
import FunctionalKit

// sourcery: lens
@available(*, deprecated, message: "Use Codable protocol instead")
public struct Path: Equatable {
	public let keys: [String]

	// sourcery:inline:Path.Init
	    public init(keys: [String]) {
	        self.keys = keys
	    }
	// sourcery:end

	public init(_ keys: String...) {
		self.keys = keys
	}
}

// MARK: - Public

extension Path: CustomStringConvertible {
    @available(*, deprecated, message: "Use Codable protocol instead")
	public var description: String {
		return keys.reduce("") { $0 + " - " + $1 }
	}
}

extension Path: ExpressibleByArrayLiteral {
    @available(*, deprecated, message: "Use Codable protocol instead")
	public typealias Element = String

    @available(*, deprecated, message: "Use Codable protocol instead")
	public init(arrayLiteral elements: String...) {
		self.keys = elements
	}
}

extension Path: ExpressibleByStringLiteral {
    
    @available(*, deprecated, message: "Use Codable protocol instead")
	public typealias UnicodeScalarLiteralType = String
    
    @available(*, deprecated, message: "Use Codable protocol instead")
	public typealias ExtendedGraphemeClusterLiteralType = String
	
    @available(*, deprecated, message: "Use Codable protocol instead")
    public typealias StringLiteralType = String

	public init(unicodeScalarLiteral value: String) {
		self.keys = [value]
	}

	public init(extendedGraphemeClusterLiteral value: String) {
		self.keys = [value]
	}

	public init(stringLiteral value: String) {
		self.keys = [value]
	}
}
