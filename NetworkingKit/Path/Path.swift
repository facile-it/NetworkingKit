import Foundation
import Abstract
import FunctionalKit

// sourcery: lens
// sourcery: equatable
public struct Path {
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
	public var description: String {
		return keys.reduce("") { $0 + " - " + $1 }
	}
}

extension Path: ExpressibleByArrayLiteral {
	public typealias Element = String

	public init(arrayLiteral elements: String...) {
		self.keys = elements
	}
}

extension Path: ExpressibleByStringLiteral {
	public typealias UnicodeScalarLiteralType = String
	public typealias ExtendedGraphemeClusterLiteralType = String
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
