import Foundation

// sourcery: init
// sourcery: lens
@available(*, deprecated, message: "Use Codable protocol instead")
public struct PathTo<Target> {
	let root: [String:Any]

	// sourcery:inline:PathTo.Init
    public init(root: [String: Any]) {
        self.root = root
    }
	// sourcery:end

	@available(*, deprecated)
	public init(in root: [String:Any]) {
		self.root = root
	}
}

// MARK: - Public

public extension PathTo {
    
    @available(*, deprecated, message: "Use Codable protocol instead")
	func get(_ path: Path) -> PathResult<Target> {
		guard path.keys.count > 0 else {
			return PathResult.failure(PathError.emptyPath(
				root: root,
				path: path))
		}

		var plistKeys = path.keys
		let lastKey = plistKeys.removeLast()

		return plistKeys
			.reduce(PathResult.success(root)) { current, key in
				current.flatMap {
					getIntermediateDict(from: $0, at: key, with: path)
				}
			}
			.flatMap { getTarget(from: $0, at: lastKey, with: path) }
			.flatMap { getCorrectTarget(from: $0, with: path) }
	}
}

// MARK: - Internal

extension PathTo {
    
    @available(*, deprecated, message: "Use Codable protocol instead")
	func getIntermediateDict(from dict: [String:Any], at key: String, with path: Path) -> PathResult<[String:Any]> {
		guard let subdict = dict[key] as? [String:Any] else {
			return .failure(PathError.noDictAtKey(
				root: self.root,
				path: path,
				key: key))
		}
		return .success(subdict)
	}

    @available(*, deprecated, message: "Use Codable protocol instead")
	func getTarget(from dict: [String:Any], at key: String, with path: Path) -> PathResult<Any> {
		guard let target = dict[key] else {
			return .failure(PathError.noTargetForLastKey(
				root: self.root,
				path: path,
				key: key))
		}
		return .success(target)
	}

    @available(*, deprecated, message: "Use Codable protocol instead")
	func getCorrectTarget(from target: Any, with path: Path) -> PathResult<Target> {
		guard let correctTarget = target as? Target else {
			return .failure(PathError.wrongTargetTypeForLastKey(
				root: self.root,
				path: path,
				typeDescription: "\(Target.self)"))
		}
		return .success(correctTarget)
	}
}
