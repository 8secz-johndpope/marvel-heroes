//
//  Created by Pablo Balduz on 07/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import XCTest
@testable import MarvelHeroesKit
import Moya
import RxSwift

class MarvelAPIClientTests: XCTestCase {
    
    let apiClient = MarvelAPIClient(MoyaProvider<MarvelEndpoint>(stubClosure: MoyaProvider.immediatelyStub))
    
    func testFetchHeroesList() {
        guard let sampleData = try? JSONDecoder().decode(MarvelResponse<Hero>.self, from: stubResponse(for: "heroes")) else {
            XCTFail()
            return
        }
        _ = apiClient.fetchHeroes().subscribe(onSuccess: { response in
            XCTAssert(response.results.count == sampleData.results.count)
            XCTAssert(response.results.first!.name == sampleData.results.first!.name)
        }) { _ in
            XCTFail()
        }
    }
}
