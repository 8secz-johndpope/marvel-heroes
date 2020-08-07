//
//  Created by Pablo Balduz on 06/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import Moya
import RxSwift

protocol MarvelAPI {
    func fetchHeroes() -> Single<MarvelResponse<Hero>>
}

struct MarvelAPIClient {
    static var environment: APIEnvironment {
        #if APPSTORE
        return .production
        #else
        return .development
        #endif
    }
    
    private let provider: MoyaProvider<MarvelEndpoint>
    
    init(_ provider: MoyaProvider<MarvelEndpoint> = MoyaProvider<MarvelEndpoint>()) {
        self.provider = provider
    }
}

extension MarvelAPIClient: MarvelAPI {
    
    func fetchHeroes() -> Single<MarvelResponse<Hero>> {
        provider.rx
            .request(.heroes)
            .filterSuccessfulStatusCodes()
            .map(MarvelResponse<Hero>.self)
    }
}
