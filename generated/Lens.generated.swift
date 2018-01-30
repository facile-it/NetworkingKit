// Generated using Sourcery 0.7.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Abstract
import FunctionalKit
import Optics


extension ClientConfiguration {
    enum lens {
        static let scheme = Lens<ClientConfiguration,String>(
            get: { $0.scheme },
			set: { part in { whole in
				return ClientConfiguration.init(
					scheme: part,
					host: whole.host,
					port: whole.port,
					rootPath: whole.rootPath,
					defaultHeaders: whole.defaultHeaders)
				} })
        static let host = Lens<ClientConfiguration,String>(
            get: { $0.host },
			set: { part in { whole in
				return ClientConfiguration.init(
					scheme: whole.scheme,
					host: part,
					port: whole.port,
					rootPath: whole.rootPath,
					defaultHeaders: whole.defaultHeaders)
				} })
        static let port = Lens<ClientConfiguration,Int?>(
            get: { $0.port },
			set: { part in { whole in
				return ClientConfiguration.init(
					scheme: whole.scheme,
					host: whole.host,
					port: part,
					rootPath: whole.rootPath,
					defaultHeaders: whole.defaultHeaders)
				} })
        static let rootPath = Lens<ClientConfiguration,String?>(
            get: { $0.rootPath },
			set: { part in { whole in
				return ClientConfiguration.init(
					scheme: whole.scheme,
					host: whole.host,
					port: whole.port,
					rootPath: part,
					defaultHeaders: whole.defaultHeaders)
				} })
        static let defaultHeaders = Lens<ClientConfiguration,[String:String]?>(
            get: { $0.defaultHeaders },
			set: { part in { whole in
				return ClientConfiguration.init(
					scheme: whole.scheme,
					host: whole.host,
					port: whole.port,
					rootPath: whole.rootPath,
					defaultHeaders: part)
				} })
    }
}

extension ConnectionInfo {
    enum lens {
        static let connectionName = Lens<ConnectionInfo,String?>(
            get: { $0.connectionName },
			set: { part in { whole in
				var m = whole; m.connectionName = part; return m
				} })
        static let request = Lens<ConnectionInfo,Request>(
            get: { $0.request },
			set: { part in { whole in
				var m = whole; m.request = part; return m
				} })
        static let response = Lens<ConnectionInfo,Response>(
            get: { $0.response },
			set: { part in { whole in
				var m = whole; m.response = part; return m
				} })
    }
}

extension ConnectionInfo.Request {
    enum lens {
        static let urlComponents = Lens<ConnectionInfo.Request,URLComponents?>(
            get: { $0.urlComponents },
			set: { part in { whole in
				var m = whole; m.urlComponents = part; return m
				} })
        static let originalRequest = Lens<ConnectionInfo.Request,URLRequest?>(
            get: { $0.originalRequest },
			set: { part in { whole in
				var m = whole; m.originalRequest = part; return m
				} })
        static let bodyStringRepresentation = Lens<ConnectionInfo.Request,String?>(
            get: { $0.bodyStringRepresentation },
			set: { part in { whole in
				var m = whole; m.bodyStringRepresentation = part; return m
				} })
    }
}

extension ConnectionInfo.Response {
    enum lens {
        static let connectionError = Lens<ConnectionInfo.Response,NSError?>(
            get: { $0.connectionError },
			set: { part in { whole in
				var m = whole; m.connectionError = part; return m
				} })
        static let serverResponse = Lens<ConnectionInfo.Response,HTTPURLResponse?>(
            get: { $0.serverResponse },
			set: { part in { whole in
				var m = whole; m.serverResponse = part; return m
				} })
        static let serverOutput = Lens<ConnectionInfo.Response,Data?>(
            get: { $0.serverOutput },
			set: { part in { whole in
				var m = whole; m.serverOutput = part; return m
				} })
        static let downloadedFileURL = Lens<ConnectionInfo.Response,URL?>(
            get: { $0.downloadedFileURL },
			set: { part in { whole in
				var m = whole; m.downloadedFileURL = part; return m
				} })
    }
}

extension HTTPResponse {
    enum lens {
		static var URLResponse: Lens<HTTPResponse,HTTPURLResponse> {
			return Lens<HTTPResponse,HTTPURLResponse>(
				get: { $0.URLResponse },
				set: { part in { whole in
					var m = whole; m.URLResponse = part; return m
				} })
		}
		static var output: Lens<HTTPResponse,Output> {
			return Lens<HTTPResponse,Output>(
				get: { $0.output },
				set: { part in { whole in
					var m = whole; m.output = part; return m
				} })
		}
    }
}

extension Multipart {
    enum lens {
        static let boundary = Lens<Multipart,String>(
            get: { $0.boundary },
			set: { part in { whole in
				var m = whole; m.boundary = part; return m
				} })
        static let contentBoundary = Lens<Multipart,String>(
            get: { $0.contentBoundary },
			set: { part in { whole in
				var m = whole; m.contentBoundary = part; return m
				} })
        static let contentBoundaryData = Lens<Multipart,Data>(
            get: { $0.contentBoundaryData },
			set: { part in { whole in
				var m = whole; m.contentBoundaryData = part; return m
				} })
        static let parts = Lens<Multipart,[Part]>(
            get: { $0.parts },
			set: { part in { whole in
				var m = whole; m.parts = part; return m
				} })
    }
}

extension Multipart.Part.File {
    enum lens {
        static let contentType = Lens<Multipart.Part.File,String>(
            get: { $0.contentType },
			set: { part in { whole in
				var m = whole; m.contentType = part; return m
				} })
        static let name = Lens<Multipart.Part.File,String>(
            get: { $0.name },
			set: { part in { whole in
				var m = whole; m.name = part; return m
				} })
        static let filename = Lens<Multipart.Part.File,String>(
            get: { $0.filename },
			set: { part in { whole in
				var m = whole; m.filename = part; return m
				} })
        static let data = Lens<Multipart.Part.File,Data>(
            get: { $0.data },
			set: { part in { whole in
				var m = whole; m.data = part; return m
				} })
    }
}

extension Multipart.Part.Text {
    enum lens {
        static let name = Lens<Multipart.Part.Text,String>(
            get: { $0.name },
			set: { part in { whole in
				var m = whole; m.name = part; return m
				} })
        static let content = Lens<Multipart.Part.Text,String>(
            get: { $0.content },
			set: { part in { whole in
				var m = whole; m.content = part; return m
				} })
    }
}

extension Path {
    enum lens {
        static let keys = Lens<Path,[String]>(
            get: { $0.keys },
			set: { part in { whole in
				return Path.init(
					keys: part)
				} })
    }
}

extension PathTo {
    enum lens {
		static var root: Lens<PathTo,[String:Any]> {
			return Lens<PathTo,[String:Any]>(
				get: { $0.root },
				set: { part in { whole in
					return PathTo.init(
						root: part)
				} })
		}
    }
}

extension Request {
    enum lens {
        static let identifier = Lens<Request,String>(
            get: { $0.identifier },
			set: { part in { whole in
				var m = whole; m.identifier = part; return m
				} })
        static let urlComponents = Lens<Request,URLComponents>(
            get: { $0.urlComponents },
			set: { part in { whole in
				var m = whole; m.urlComponents = part; return m
				} })
        static let method = Lens<Request,HTTPMethod>(
            get: { $0.method },
			set: { part in { whole in
				var m = whole; m.method = part; return m
				} })
        static let headers = Lens<Request,[String:String]>(
            get: { $0.headers },
			set: { part in { whole in
				var m = whole; m.headers = part; return m
				} })
        static let body = Lens<Request,Data?>(
            get: { $0.body },
			set: { part in { whole in
				var m = whole; m.body = part; return m
				} })
    }
}
