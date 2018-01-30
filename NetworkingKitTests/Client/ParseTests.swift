import NetworkingKit
import XCTest
import SwiftCheck
import FunctionalKit

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
                    onSuccess: { _ in true },
                    onFailure: { _ in false })
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
                    onSuccess: { _ in false },
                    onFailure: { _ in true })
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
}
