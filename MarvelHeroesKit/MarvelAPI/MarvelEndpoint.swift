//
//  Created by Pablo Balduz on 07/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import Moya

enum MarvelEndpoint: TargetType {
    case heroes
    
    var baseURL: URL {
        return MarvelAPIClient.environment.baseURL
    }
    
    var path: String {
        switch self {
        case .heroes:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .heroes:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .heroes:
            return stubResponse(for: "heroes")
        }
    }
    
    var task: Task {
        switch self {
        case .heroes:
            let ts = "\(Date().timeIntervalSince1970)"
            let params = [
                "ts": ts,
                "apikey": MarvelAuth.publicKey,
                "hash": MarvelAuth.hash(ts: ts)
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        ["Content-type": "application/json"]
    }
}
