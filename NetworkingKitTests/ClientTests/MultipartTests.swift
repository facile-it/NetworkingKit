@testable import NetworkingKit
import XCTest
import SwiftCheck
import Nimble

class MultipartTests: XCTestCase {

	func testCorrectBoundaryData() {
		property("Multipart always generates correct boundaryData from a string") <- forAll { (boundary: String) in
			let multipart = Multipart(boundary: boundary)
			let expectedData = (Multipart.preBoundaryString + boundary).data(using: .utf8)!
			return multipart.contentBoundaryData == expectedData
		}
	}

	func testCorrectHeader() {
		property("Multipart generates correct ContentType header from boundary") <- forAll { (boundary: String) in
			let multipart = Multipart(boundary: boundary)
			let expectedContentType = "multipart/form-data; boundary=\(boundary)"
			let generatedContentType = multipart.headers["Content-Type"]!
			return generatedContentType == expectedContentType
		}
	}

	func testCorrectPartsCountAppending() {

		let x0 = Multipart(boundary: "boundary")

		expect(x0.parts.count).to(equal(0))

		let x1 = x0.adding(part: .text(.init(name: "", content: "")))

		expect(x1.parts.count).to(equal(1))

		let x3 = x1
			.adding(part: .text(.init(name: "", content: "")))
			.adding(part: .text(.init(name: "", content: "")))

		expect(x3.parts.count).to(equal(3))
	}

	func testCorrectTextPartDataGeneration() {
		property("Multipart.Part.Text always generates the correct data") <- forAll { (part: Multipart.Part.Text) in
			let expectedNameString = "name=\"\(part.name)\""
			let expectedContentString = "\r\n\r\n\(part.content)"
			let dataString = String(data: try! part.getData(), encoding: .utf8)!

			return dataString.contains(expectedNameString)
				&& dataString.contains(expectedContentString)
		}
	}

	func testCorrectFilePartDataGeneration() {
		property("Multipart.Part.File always generates the correct data") <- forAll { (part: Multipart.Part.File) in
			let expectedNameString = "name=\"\(part.name)\""
			let expectedContentTypeString = "Content-Type: \(part.contentType)"
			let expectedDataString = "\r\n\r\n" + String(data: part.data, encoding: .utf8)!
			let dataString = String(data: try! part.getData(), encoding: .utf8)!

			return dataString.contains(expectedNameString)
				&& dataString.contains(expectedContentTypeString)
				&& dataString.contains(expectedDataString)
		}
	}

	func testCorrectNumberOfElements() {
		property("Multipart has correct count for each element in body", arguments: .with(97793187,1645514869,1)) <- forAll { (multi: Multipart) in
			(multi.contentBoundary.isEmpty == false && multi.parts.count > 0) ==> {
				let dataString = String(data: try! multi.getData(), encoding: .utf8)!

				let expectedContentDispositionCount = multi.parts.count
				let gotContentDispositionCount = dataString
					.components(separatedBy: "Content-Disposition: form-data;")
					.count - 1

				let expectedBoundariesCount = multi.parts.count > 0 ? (multi.parts.count + 1) : 0
				let gotBoundariesCount = dataString
					.components(separatedBy: multi.contentBoundary)
					.count - 1

				let expectedFileCount = multi.parts.filter { if case .file = $0 { return true } else { return false } }.count
				let gotFileCount = dataString
					.components(separatedBy: "filename=\"")
					.count - 1

				let expectedTextCount = multi.parts.filter { if case .text = $0 { return true } else { return false } }.count
				let gotTextCount = multi.parts.count - expectedFileCount

				return expectedContentDispositionCount == gotContentDispositionCount
					&& expectedBoundariesCount == gotBoundariesCount
					&& expectedFileCount == gotFileCount
					&& expectedTextCount == gotTextCount
			}
		}
	}

	func testCorrectBoundariesPrefixAndSuffix() {
		property("Multipart body ha always boundary prefix and postfix") <- forAll { (multi: Multipart) in
			(multi.contentBoundary.isEmpty == false && multi.parts.count > 0) ==> {
				let dataString = String(data: try! multi.getData(), encoding: .utf8)!
				return dataString.hasPrefix(multi.contentBoundary)
					&& dataString.hasSuffix(multi.lastContentBoundary)
			}
		}
	}
}
