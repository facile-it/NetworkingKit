// Generated using Sourcery 1.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import Foundation
import FunctionalKit



extension ConnectionConfiguration {
    public enum lens {

        public static let scheme = Lens<ConnectionConfiguration,String>(
            get: { $0.scheme },
			set: { part in
				{ whole in
					ConnectionConfiguration.init(
						scheme: part,
						host: whole.host,
						port: whole.port,
						rootPath: whole.rootPath,
						defaultHeaders: whole.defaultHeaders)
				}
		})

        public static let host = Lens<ConnectionConfiguration,String>(
            get: { $0.host },
			set: { part in
				{ whole in
					ConnectionConfiguration.init(
						scheme: whole.scheme,
						host: part,
						port: whole.port,
						rootPath: whole.rootPath,
						defaultHeaders: whole.defaultHeaders)
				}
		})

        public static let port = Lens<ConnectionConfiguration,Int?>(
            get: { $0.port },
			set: { part in
				{ whole in
					ConnectionConfiguration.init(
						scheme: whole.scheme,
						host: whole.host,
						port: part,
						rootPath: whole.rootPath,
						defaultHeaders: whole.defaultHeaders)
				}
		})

        public static let rootPath = Lens<ConnectionConfiguration,String?>(
            get: { $0.rootPath },
			set: { part in
				{ whole in
					ConnectionConfiguration.init(
						scheme: whole.scheme,
						host: whole.host,
						port: whole.port,
						rootPath: part,
						defaultHeaders: whole.defaultHeaders)
				}
		})

        public static let defaultHeaders = Lens<ConnectionConfiguration,[String:String]?>(
            get: { $0.defaultHeaders },
			set: { part in
				{ whole in
					ConnectionConfiguration.init(
						scheme: whole.scheme,
						host: whole.host,
						port: whole.port,
						rootPath: whole.rootPath,
						defaultHeaders: part)
				}
		})
    }
}


extension ConnectionContext {
    public enum lens {

		public static var connection: Lens<ConnectionContext,Connection> {
			return Lens<ConnectionContext,Connection>(
				get: { $0.connection },
				set: { part in
				    { whole in
					    ConnectionContext.init(
						    connection: part,
						    configuration: whole.configuration,
						    environment: whole.environment)
					}
	        })
		}

		public static var configuration: Lens<ConnectionContext,ConnectionConfiguration> {
			return Lens<ConnectionContext,ConnectionConfiguration>(
				get: { $0.configuration },
				set: { part in
				    { whole in
					    ConnectionContext.init(
						    connection: whole.connection,
						    configuration: part,
						    environment: whole.environment)
					}
	        })
		}

		public static var environment: Lens<ConnectionContext,Environment> {
			return Lens<ConnectionContext,Environment>(
				get: { $0.environment },
				set: { part in
				    { whole in
					    ConnectionContext.init(
						    connection: whole.connection,
						    configuration: whole.configuration,
						    environment: part)
					}
	        })
		}
    }
}


extension ConnectionInfo {
    public enum lens {

        public static let connectionName = Lens<ConnectionInfo,String?>(
            get: { $0.connectionName },
			set: { part in
				{ whole in
					var m = whole
					m.connectionName = part
					return m
				}
		})

        public static let request = Lens<ConnectionInfo,Request>(
            get: { $0.request },
			set: { part in
				{ whole in
					var m = whole
					m.request = part
					return m
				}
		})

        public static let response = Lens<ConnectionInfo,Response>(
            get: { $0.response },
			set: { part in
				{ whole in
					var m = whole
					m.response = part
					return m
				}
		})
    }
}


extension ConnectionInfo.Request {
    public enum lens {

        public static let urlComponents = Lens<ConnectionInfo.Request,URLComponents?>(
            get: { $0.urlComponents },
			set: { part in
				{ whole in
					var m = whole
					m.urlComponents = part
					return m
				}
		})

        public static let originalRequest = Lens<ConnectionInfo.Request,URLRequest?>(
            get: { $0.originalRequest },
			set: { part in
				{ whole in
					var m = whole
					m.originalRequest = part
					return m
				}
		})

        public static let bodyStringRepresentation = Lens<ConnectionInfo.Request,String?>(
            get: { $0.bodyStringRepresentation },
			set: { part in
				{ whole in
					var m = whole
					m.bodyStringRepresentation = part
					return m
				}
		})
    }
}


extension ConnectionInfo.Response {
    public enum lens {

        public static let connectionError = Lens<ConnectionInfo.Response,NSError?>(
            get: { $0.connectionError },
			set: { part in
				{ whole in
					var m = whole
					m.connectionError = part
					return m
				}
		})

        public static let serverResponse = Lens<ConnectionInfo.Response,HTTPURLResponse?>(
            get: { $0.serverResponse },
			set: { part in
				{ whole in
					var m = whole
					m.serverResponse = part
					return m
				}
		})

        public static let serverOutput = Lens<ConnectionInfo.Response,Data?>(
            get: { $0.serverOutput },
			set: { part in
				{ whole in
					var m = whole
					m.serverOutput = part
					return m
				}
		})

        public static let downloadedFileURL = Lens<ConnectionInfo.Response,URL?>(
            get: { $0.downloadedFileURL },
			set: { part in
				{ whole in
					var m = whole
					m.downloadedFileURL = part
					return m
				}
		})
    }
}


extension HTTPRequest {
    public enum lens {

        public static let identifier = Lens<HTTPRequest,String>(
            get: { $0.identifier },
			set: { part in
				{ whole in
					var m = whole
					m.identifier = part
					return m
				}
		})

        public static let urlComponents = Lens<HTTPRequest,URLComponents>(
            get: { $0.urlComponents },
			set: { part in
				{ whole in
					var m = whole
					m.urlComponents = part
					return m
				}
		})

        public static let method = Lens<HTTPRequest,HTTPMethod>(
            get: { $0.method },
			set: { part in
				{ whole in
					var m = whole
					m.method = part
					return m
				}
		})

        public static let headers = Lens<HTTPRequest,[String:String]>(
            get: { $0.headers },
			set: { part in
				{ whole in
					var m = whole
					m.headers = part
					return m
				}
		})

        public static let body = Lens<HTTPRequest,Data?>(
            get: { $0.body },
			set: { part in
				{ whole in
					var m = whole
					m.body = part
					return m
				}
		})
    }
}


extension HTTPResponse {
    public enum lens {

		public static var URLResponse: Lens<HTTPResponse,HTTPURLResponse> {
			return Lens<HTTPResponse,HTTPURLResponse>(
				get: { $0.URLResponse },
				set: { part in
				    { whole in
						var m = whole
                        m.URLResponse = part
                        return m
					}
	        })
		}

		public static var output: Lens<HTTPResponse,Output> {
			return Lens<HTTPResponse,Output>(
				get: { $0.output },
				set: { part in
				    { whole in
						var m = whole
                        m.output = part
                        return m
					}
	        })
		}
    }
}


extension Multipart {
    public enum lens {

        public static let boundary = Lens<Multipart,String>(
            get: { $0.boundary },
			set: { part in
				{ whole in
					var m = whole
					m.boundary = part
					return m
				}
		})

        public static let contentBoundary = Lens<Multipart,String>(
            get: { $0.contentBoundary },
			set: { part in
				{ whole in
					var m = whole
					m.contentBoundary = part
					return m
				}
		})

        public static let lastContentBoundary = Lens<Multipart,String>(
            get: { $0.lastContentBoundary },
			set: { part in
				{ whole in
					var m = whole
					m.lastContentBoundary = part
					return m
				}
		})

        public static let contentBoundaryData = Lens<Multipart,Data>(
            get: { $0.contentBoundaryData },
			set: { part in
				{ whole in
					var m = whole
					m.contentBoundaryData = part
					return m
				}
		})

        public static let lastContentBoundaryData = Lens<Multipart,Data>(
            get: { $0.lastContentBoundaryData },
			set: { part in
				{ whole in
					var m = whole
					m.lastContentBoundaryData = part
					return m
				}
		})

        public static let parts = Lens<Multipart,[Part]>(
            get: { $0.parts },
			set: { part in
				{ whole in
					var m = whole
					m.parts = part
					return m
				}
		})
    }
}


extension Multipart.Part.File {
    public enum lens {

        public static let contentType = Lens<Multipart.Part.File,String>(
            get: { $0.contentType },
			set: { part in
				{ whole in
					var m = whole
					m.contentType = part
					return m
				}
		})

        public static let name = Lens<Multipart.Part.File,String>(
            get: { $0.name },
			set: { part in
				{ whole in
					var m = whole
					m.name = part
					return m
				}
		})

        public static let filename = Lens<Multipart.Part.File,String>(
            get: { $0.filename },
			set: { part in
				{ whole in
					var m = whole
					m.filename = part
					return m
				}
		})

        public static let data = Lens<Multipart.Part.File,Data>(
            get: { $0.data },
			set: { part in
				{ whole in
					var m = whole
					m.data = part
					return m
				}
		})
    }
}


extension Multipart.Part.Text {
    public enum lens {

        public static let name = Lens<Multipart.Part.Text,String>(
            get: { $0.name },
			set: { part in
				{ whole in
					var m = whole
					m.name = part
					return m
				}
		})

        public static let content = Lens<Multipart.Part.Text,String>(
            get: { $0.content },
			set: { part in
				{ whole in
					var m = whole
					m.content = part
					return m
				}
		})
    }
}

