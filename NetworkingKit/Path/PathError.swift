import Foundation
import Abstract
import FunctionalKit

public typealias PathResult<T> = Result<T, PathError>

// sourcery: prism
// sourcery: match
public enum PathError: Error {
	case emptyPath(root: [String:Any], path: Path)
	case noDictAtKey(root: [String:Any], path: Path, key: String)
	case noTargetForLastKey(root: [String:Any], path: Path, key: String)
	case wrongTargetTypeForLastKey(root: [String:Any], path: Path, typeDescription: String)
	case wrongTargetContentForLastKey(root: [String:Any], path: Path, contentDescription: String)
	case multiple([PathError])
}

// MARK: - Public

public extension PathError {
	var getNSError: NSError {
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
    
    static func wrongDateFormat(root: [String: Any], path: Path, string: String) -> PathError {
        return PathError.wrongTargetContentForLastKey(
            root: root,
            path: path,
            contentDescription: "\(string) should be an appropriate ISO8601 date string")
    }
}

extension PathError: Equatable {
	public static func == (left: PathError, right: PathError) -> Bool {
		return left.debugDescription == right.debugDescription
	}
}

extension PathError: CustomDebugStringConvertible {
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
}

extension PathError: Monoid {
	public static var empty: PathError {
		return .multiple([])
	}

	public static func <> (left: PathError, right: PathError) -> PathError {
		switch (left, right) {
		case (.empty, _):
			return right
		case (_ , .empty):
			return left
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
