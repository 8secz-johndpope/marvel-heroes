//
//  Created by Pablo Balduz on 09/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import XCTest
import MarvelHeroesKit
import RxSwift
@testable import MarvelHeroes
import SnapshotTesting

class HeroesViewControllersTests: XCTestCase {
    
    struct HeroesServiceStub: HeroesService {
        
        let listStub = Array(repeating: Hero(id: 0,
                                             name: "Spiderman",
                                             description: "",
                                             thumbnail: ("", "")), count: 10)
        
        let detailStub = HeroDetail(id: 0,
                                    name: "Spiderman",
                                    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                                    thumbnail: Thumbnail(path: "", ext: ""))
        
        func fetchHeros(query: String?) -> Single<[Hero]> {
            .just(listStub)
        }
        
        func fetchHeroDetail(id: Int) -> Single<HeroDetail> {
            .just(detailStub)
        }
    }
        
    func testViewControllerHeroesList() {
        let vm = HeroesListViewModel(service: HeroesServiceStub())
        let vc = UINavigationController(rootViewController: HeroesListViewController(viewModel: vm))
        
        assertSnapshot(matching: vc, as: .image, record: false)
    }
    
    func testViewControllerHeroDetail() {
        let vm = HeroDetailViewModel(heroID: 0, service: HeroesServiceStub())
        let vc = HeroDetailViewController(viewModel: vm)
        
        assertSnapshot(matching: vc, as: .image, record: false)
    }
}
