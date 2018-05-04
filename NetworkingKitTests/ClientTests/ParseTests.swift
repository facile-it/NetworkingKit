import NetworkingKit
import XCTest
import SwiftCheck
import FunctionalKit
import Nimble

class ParseTests: XCTestCase {
    func testParseResponse() {
        property("`acceptOnly(httpCodes:,parseErrorsWith:)` always returns .success if accepted contains response http code") <- forAll { (httpCode: HTTPCode, url: URL) in
            let urlResponse = HTTPURLResponse.init(
                url: url,
                statusCode: httpCode.code,
                httpVersion: nil,
                headerFields: nil)!
            let data = Data.init()
            let httpResponse = HTTPResponse<Data>.init(URLResponse: urlResponse, output: data)
            
            return Parse.Response.acceptOnly(httpCodes: [httpCode.code])(httpResponse)
                .fold(
                    onSuccess: f.pure(true),
                    onFailure: f.pure(false))
        }
        
        property("`acceptOnly(httpCodes:,parseErrorsWith:)` always returns .failure(.invalidHTTPCode) if accepted does not contain response http code") <- forAll { (httpCode: HTTPCode, url: URL) in
            let urlResponse = HTTPURLResponse.init(
                url: url,
                statusCode: httpCode.code,
                httpVersion: nil,
                headerFields: nil)!
            let data = Data.init()
            let httpResponse = HTTPResponse<Data>.init(URLResponse: urlResponse, output: data)
            
            let wrongCode = httpCode.code == 200
                ? 400
                : 200
            return Parse.Response.acceptOnly(httpCodes: [wrongCode])(httpResponse)
                .fold(
                    onSuccess: f.pure(false),
                    onFailure: f.pure(true))
        }
        
        property("`checkUnauthorized(withHTTPCodes:)` returns always .success if response code is not 401, else .failure(.unauthorized)") <- forAll { (httpCode: HTTPCode, url: URL) in
            let urlResponse = HTTPURLResponse.init(
                url: url,
                statusCode: httpCode.code,
                httpVersion: nil,
                headerFields: nil)!
            let data = Data.init()
            let httpResponse = HTTPResponse<Data>.init(URLResponse: urlResponse, output: data)
            
            return Parse.Response.checkUnauthorized()(httpResponse)
                .fold(
                    onSuccess: { _ in httpCode.code != 401},
                    onFailure: {
                        switch($0) {
                        case .unauthorized:
                            return true
                        default:
                            return false
                        } })
        }
    }

	func testGetHeaderCaseSensitiveFailure() {
		let headers = ["Aaa" : "42"]

        let urlResponse = HTTPURLResponse.init(
			url: URL.init(string: "https://www.facile.it")!,
			statusCode: 200,
			httpVersion: nil,
			headerFields: headers)!

		let data = "hi".data(using: .utf8)!

		let response = HTTPResponse.init(URLResponse: urlResponse, output: data)

		let result = Parse.Response.getHeader(at: "aaa", caseSensitive: true)(response)

		expect(result.toOptionalValue()).to(beNil())
	}

	func testGetHeaderCaseSensitiveSuccess() {
		let headers = ["Aaa" : "42"]

		let urlResponse = HTTPURLResponse.init(
			url: URL.init(string: "https://www.facile.it")!,
			statusCode: 200,
			httpVersion: nil,
			headerFields: headers)!

		let data = "hi".data(using: .utf8)!

		let response = HTTPResponse.init(URLResponse: urlResponse, output: data)

		let result = Parse.Response.getHeader(at: "Aaa", caseSensitive: true)(response)

		expect(result.toOptionalValue()).to(equal("42"))
	}

	func testGetHeaderCaseInsensitiveFailure() {
		let headers = ["Aaa" : "42"]

		let urlResponse = HTTPURLResponse.init(
			url: URL.init(string: "https://www.facile.it")!,
			statusCode: 200,
			httpVersion: nil,
			headerFields: headers)!

		let data = "hi".data(using: .utf8)!

		let response = HTTPResponse.init(URLResponse: urlResponse, output: data)

		let result = Parse.Response.getHeader(at: "aab")(response)

		expect(result.toOptionalValue()).to(beNil())
	}

	func testGetHeaderCaseInsensitiveSuccess() {
		let headers = ["Aaa" : "42"]

		let urlResponse = HTTPURLResponse.init(
			url: URL.init(string: "https://www.facile.it")!,
			statusCode: 200,
			httpVersion: nil,
			headerFields: headers)!

		let data = "hi".data(using: .utf8)!

		let response = HTTPResponse.init(URLResponse: urlResponse, output: data)

		let result = Parse.Response.getHeader(at: "aaa")(response)

		expect(result.toOptionalValue()).to(equal("42"))
	}
}


