//
//  Created by Pablo Balduz on 06/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import Moya
import RxSwift

public protocol MarvelAPI {
    func fetchHeroes(query: String?) -> Single<[Hero]>
    func fetchHeroDetail(heroID: Int) -> Single<HeroDetail>
}

public struct MarvelAPIClient {
    static var environment: APIEnvironment {
        #if APPSTORE
        return .production
        #else
        return .development
        #endif
    }
    
    private let provider: MoyaProvider<MarvelEndpoint>
    
    public init(_ provider: MoyaProvider<MarvelEndpoint> = MoyaProvider<MarvelEndpoint>()) {
        self.provider = provider
    }
}

extension MarvelAPIClient: MarvelAPI {
    
    public func fetchHeroes(query: String?) -> Single<[Hero]> {
        provider.rx
            .request(.heroes(query: query))
            .filterSuccessfulStatusCodes()
            .map(MarvelResponse<Hero>.self)
            .map { return $0.results }
    }
    
    public func fetchHeroDetail(heroID: Int) -> Single<HeroDetail> {
        provider.rx
            .request(.heroDetail(heroID: heroID))
            .filterSuccessfulStatusCodes()
            .map(MarvelResponse<HeroDetail>.self)
            .map { $0.results.first! }
    }
}
