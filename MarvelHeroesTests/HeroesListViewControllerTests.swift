//
//  Created by Pablo Balduz on 09/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import XCTest
import MarvelHeroesKit
import RxSwift
@testable import MarvelHeroes
import SnapshotTesting

class HeroesListViewControllerTests: XCTestCase {
    
    struct HeroesServiceStub: HeroesService {
        
        let stub = [
            Hero(id: 0, name: "spiderman", description: "description spiderman", thumbnail: ("", "")),
            Hero(id: 0, name: "ironman", description: "description ironman", thumbnail: ("", "")),
            Hero(id: 0, name: "hulk", description: "description hulk", thumbnail: ("", ""))
        ]
        
        func fetchHeros(query: String?) -> Single<[Hero]> {
            .just(stub)
        }
    }
    
    func testViewControllerHeroesList() {
        let vm = HeroesListViewModel(service: HeroesServiceStub())
        let vc = UINavigationController(rootViewController: HeroesListViewController(viewModel: vm))
        
        assertSnapshot(matching: vc, as: .image, record: true)
    }
}

