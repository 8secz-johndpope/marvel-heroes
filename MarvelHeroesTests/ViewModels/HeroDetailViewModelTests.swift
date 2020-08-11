//
//  Created by Pablo Balduz on 10/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import XCTest
import RxSwift
import MarvelHeroesKit
@testable import MarvelHeroes

class HeroDetailViewModelTests: XCTestCase {
    
    struct HeroesServiceStub: HeroesService {
        let stub = HeroDetail(id: 0, name: "spiderman", description: "spiderman description", thumbnail: Thumbnail(path: "", ext: ""))
        
        private let emptyContent: Bool
        
        init(emptyContent: Bool = false) {
            self.emptyContent = emptyContent
        }
        
        func fetchHeros(query: String?) -> Single<[Hero]> {
            .just([])
        }
        
        func fetchHeroDetail(id: Int) -> Single<HeroDetail> {
            .just(stub)
        }
    }
    
    func testInitialStateEmpty() {
        let vm = HeroDetailViewModel(heroID: 0, service: HeroesServiceStub())
        let spy = StateSpy(vm.state)
        XCTAssertEqual(spy.values, [.empty])
    }
    
    func testLoadContentChangesState() {
        let service = HeroesServiceStub()
        let vm = HeroDetailViewModel(heroID: 0, service: service)
        let spy = StateSpy(vm.state)
        vm.loadDetail()
        XCTAssertEqual(spy.values, [.empty,
                                    .detail(service.stub)
        ])
    }    
}
