import Abstract
import FunctionalKit

public typealias PathResult<T> = Result<PathError,T>

public struct Path: CustomStringConvertible {
	public let keys: [String]
	public init(_ keys: String...) {
		self.keys = keys
	}
    
    public init(keysArray: [String]) {
        self.keys = keysArray
    }

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

extension Path: Equatable {
    public static func == (left: Path, right: Path) -> Bool {
        return left.keys == right.keys
    }
}

public enum PathError: Error, CustomDebugStringConvertible {

	case emptyPath(root: [String:Any], path: Path)
	case noDictAtKey(root: [String:Any], path: Path, key: String)
	case noTargetForLastKey(root: [String:Any], path: Path, key: String)
	case wrongTargetTypeForLastKey(root: [String:Any], path: Path, typeDescription: String)
	case wrongTargetContentForLastKey(root: [String:Any], path: Path, contentDescription: String)
    case multiple([PathError])

	public var debugDescription: String {
		switch self {
		case .emptyPath(let root, let path):
			return "Empty path (root: \(root); path: \(path))"
		case .noDictAtKey(let root, let path, let key):
			return "No dict at key (root: \(root); path: \(path); key: \(key))"
		case .noTargetForLastKey(let root, let path, let key):
			return "No target for last key (root: \(root); path: \(path); key: \(key))"
		case .wrongTargetTypeForLastKey(let root, let path, let typeDescription):
			return "Wrong target type for last key (root: \(root); path: \(path); typeDescription: \(typeDescription))"
		case .wrongTargetContentForLastKey(let root, let path, let contentDescription):
			return "Wrong target content for last key (root: \(root); path: \(path); contentDescription: \(contentDescription))"
        case .multiple(let pathErrors):
            return pathErrors
                .map { "\($0.debugDescription)\n" }
                .joined()
        }
	}

	public var getNSError: NSError {
		let domain = "Path"
		switch self {
		case .emptyPath(let root, let path):
			return NSError(
				domain: domain,
				code: 0,
				userInfo: [
					"root" : root,
					"path" : path,
					NSLocalizedDescriptionKey: "PathError.emptyPath"])
		case .noDictAtKey(let root, let path, let key):
			return NSError(
				domain: domain,
				code: 1,
				userInfo: [
					"root" : root,
					"path" : path,
					"key" : key,
					NSLocalizedDescriptionKey: "PathError.noDictAtKey(key: \(key))"])
		case .noTargetForLastKey(let root, let path, let key):
			return NSError(
				domain: domain,
				code: 2,
				userInfo: [
					"root" : root,
					"path" : path,
					"key" : key,
					NSLocalizedDescriptionKey: "PathError.noTargetForLastKey(key: \(key))"])
		case .wrongTargetTypeForLastKey(let root, let path, let typeDescription):
			return NSError(
				domain: domain,
				code: 3,
				userInfo: [
					"root" : root,
					"path" : path,
					"typeDescription" : typeDescription,
					NSLocalizedDescriptionKey: "PathError.wrongTargetTypeForLastKey(type: \(typeDescription))"])
		case .wrongTargetContentForLastKey(let root, let path, let contentDescription):
			return NSError(
				domain: domain,
				code: 4,
				userInfo: [
					"root" : root,
					"path" : path,
					"contentDescription" : contentDescription,
					NSLocalizedDescriptionKey: "PathError.wrongTargetContentForLastKey(content: \(contentDescription))"])
        case.multiple(let pathErrors):
            return NSError.init(
                domain: domain,
                code: 5,
                userInfo: ["multiple": [pathErrors.map { $0.getNSError }],
                           NSLocalizedDescriptionKey: "PathError.multiple"])
        }
	}
}

extension PathError: Semigroup {
    public static func <> (left: PathError, right: PathError) -> PathError {
        switch (left, right) {
        case (.multiple(let leftErrors), .multiple(let rightErrors)):
            return PathError.multiple(leftErrors + rightErrors)
        case (.multiple(let leftErrors), _):
            return PathError.multiple(leftErrors + [right])
        case (_ , .multiple(let rightErrors)):
            return PathError.multiple([left] + rightErrors)
        default:
            return PathError.multiple([left, right])
        }
    }
}

extension PathError: Equatable {
    public static func == (left: PathError, right: PathError) -> Bool {
        return left.debugDescription == right.debugDescription
    }
}

public struct PathTo<Target> {
	let root: [String:Any]
	public init(in root: [String:Any]) {
		self.root = root
	}

	public func get(_ path: Path) -> PathResult<Target> {
		guard path.keys.count > 0 else {
			return PathResult.failure(PathError.emptyPath(
				root: root,
				path: path))
		}

		var plistKeys = path.keys
		let lastKey = plistKeys.removeLast()

		return plistKeys
			.reduce(PathResult.success(root)) { current, key in
				current.flatMap { (dict: [String:Any]) -> PathResult<[String:Any]> in
					guard let subdict = dict[key] as? [String:Any] else {
						return .failure(PathError.noDictAtKey(
							root: self.root,
							path: path,
							key: key))
					}
					return .success(subdict)
				}
			}
			.flatMap { (dict: [String:Any]) -> PathResult<Target> in
				guard let target = dict[lastKey] else {
					return .failure(PathError.noTargetForLastKey(
						root: self.root,
						path: path,
						key: lastKey))
				}
				guard let correctTarget = target as? Target else {
					return .failure(PathError.wrongTargetTypeForLastKey(
						root: self.root,
						path: path,
						typeDescription: "\(Target.self)"))
				}
				return .success(correctTarget)
		}
	}
}
