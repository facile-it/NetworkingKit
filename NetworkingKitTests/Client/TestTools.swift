import Foundation
import SwiftCheck
import Abstract
@testable import NetworkingKit
import FunctionalKit

struct URLStringGenerator {
	static var get: Gen<String> {

		func glue(_ parts: Gen<String>...) -> Gen<String> {
			return sequence(parts).map { $0.reduce("", +) }
		}

		return glue(
			Gen.pure("http://"),
			String.arbitrary,
			Gen.pure("."),
			String.arbitrary.resize(3),
			Gen.pure("/"),
			String.arbitrary)
	}
}

extension Gen where A: OptionalType, A.ParameterType: Arbitrary {
	var flip: Gen<OptionalOf<A.ParameterType>> {
		return map { $0.fold(
			onNone: { OptionalOf(nil) },
			onSome: { OptionalOf($0) })
        }
	}
}

extension ConnectionInfo: Arbitrary {
	public static var arbitrary: Gen<ConnectionInfo> {
		let optionalArbitraryURLComponents = URLStringGenerator.get.map(URLComponents.init)
		let optionalArbitraryURLRequest = URLStringGenerator.get.map { (string: String) -> URLRequest? in URL.init(string: string).map { (url: URL) -> URLRequest in URLRequest.init(url: url) } }
		let optionalArbitraryURLResponse = URLStringGenerator.get.map { URL(string: $0).map { HTTPURLResponse(url: $0, mimeType: nil, expectedContentLength: 0, textEncodingName: nil) } }
		let optionalArbitraryServerOutput = OptionalOf<String>.arbitrary.map { $0.getOptional.flatMap { $0.data(using: .utf8, allowLossyConversion: true) }}
		let optionalArbitraryDownloadedFileURL = URLStringGenerator.get.map { URL.init(string: $0) }

		return Gen<ConnectionInfo>.compose {
			ConnectionInfo.init(
				connectionName: $0.generate(),
				urlComponents: $0.generate(using: optionalArbitraryURLComponents),
				originalRequest: $0.generate(using: optionalArbitraryURLRequest),
				bodyStringRepresentation: $0.generate(),
				connectionError: NSError(domain: $0.generate(), code: $0.generate(), userInfo: nil),
				serverResponse: $0.generate(using: optionalArbitraryURLResponse),
				serverOutput: $0.generate(using: optionalArbitraryServerOutput),
				downloadedFileURL: $0.generate(using: optionalArbitraryDownloadedFileURL))
		}
	}
}

extension CheckerArguments {
	static func with(_ left: Int, _ right: Int, _ size: Int) -> CheckerArguments {
		return CheckerArguments(
			replay: .some((StdGen(left,right),size)))
	}
}

extension Multipart.Part.Text: Arbitrary {
	public static var arbitrary: Gen<Multipart.Part.Text> {
		return Gen<Multipart.Part.Text>.compose {
			Multipart.Part.Text(
				name: $0.generate(),
				content: $0.generate())
		}
	}
}

extension Multipart.Part.File: Arbitrary {
	public static var arbitrary: Gen<Multipart.Part.File> {
		return Gen<Multipart.Part.File>.compose {
			Multipart.Part.File(
				contentType: $0.generate(),
				name: $0.generate(),
				filename: $0.generate(),
				data: $0.generate(using: String.arbitrary
					.map { $0.data(using: .utf8)! }))
		}
	}
}

extension Multipart.Part: Arbitrary {
	public static var arbitrary: Gen<Multipart.Part> {
		return Gen<Int>.fromElements(of: [0,1]).flatMap {
			switch $0 {
			case 0:
				return Multipart.Part.Text.arbitrary.map(Multipart.Part.text)
			case 1:
				return Multipart.Part.File.arbitrary.map(Multipart.Part.file)
			default:
				fatalError()
			}
		}
	}
}

extension Multipart: Arbitrary {
	public static var arbitrary: Gen<Multipart> {
		return Gen<Multipart>.compose {
			Multipart(
				boundary: $0.generate(),
				parts: $0.generate(using: ArrayOf<Multipart.Part>.arbitrary.map { $0.getArray }))
		}
	}
}
