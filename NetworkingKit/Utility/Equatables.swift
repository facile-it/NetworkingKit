import Foundation
import FunctionalKit

public func == <A,B> (lhs: [A : B]?, rhs: [A : B]?) -> Bool where B: Equatable {
	switch (lhs,rhs) {
	case (nil, nil):
		return true
	case (let left?, let right?):
		return left == right
	default:
		return false
	}
}
