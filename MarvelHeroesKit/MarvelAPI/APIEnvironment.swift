//
//  Created by Pablo Balduz on 07/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

enum APIEnvironment {
    case production
    case development
    
    var baseURL: URL {
        switch self {
        case .production:
            return URL(string: "https://gateway.marvel.com")!
        case .development:
            return URL(string: "https://gateway.marvel.com")!
        }
    }
}
