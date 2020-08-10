//
//  HeroesListViewModel.swift
//  MarvelHeroesTests
//
//  Created by Pablo Balduz on 07/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import XCTest
import RxSwift
import MarvelHeroesKit
@testable import MarvelHeroes

class HeroesListViewModelTests: XCTestCase {
    
    
    struct HeroesServiceStub: HeroesService {
        let stub = [
            Hero(id: 0, name: "spiderman", description: "description spiderman", thumbnail: ("", "")),
            Hero(id: 0, name: "spiderman", description: "description spiderman", thumbnail: ("", ""))
        ]
        
        private let emptyContent: Bool
        
        init(emptyContent: Bool = false) {
            self.emptyContent = emptyContent
        }
        
        func fetchHeros(query: String?) -> Single<[Hero]> {
            emptyContent ? .just([]) : .just(stub)
        }
    }
    
    class StateSpy {
        private(set) var values = [HeroesListViewModel.State]()
        private let disposeBag = DisposeBag()
        
        init(_ observable: Observable<HeroesListViewModel.State>) {
            observable.subscribe(onNext: { [weak self] state in
                self?.values.append(state)
            }).disposed(by: disposeBag)
        }
    }

    func testInitialStateEmtpy() {
        let service = HeroesServiceStub()
        let vm = HeroesListViewModel(service: service)
        let spy = StateSpy(vm.state)
        XCTAssertEqual(spy.values, [.empty])
    }
    
    func testLoadContentChangesState() {
        let service = HeroesServiceStub()
        let vm = HeroesListViewModel(service: service)
        let spy = StateSpy(vm.state)
        vm.loadHeroes()
        XCTAssertEqual(spy.values, [.empty,
                                    .list(service.stub.map(CellViewModel.init))
        ])
    }
    
    func testLoadContentEmptyChangesState() {
        let service = HeroesServiceStub(emptyContent: true)
        let vm = HeroesListViewModel(service: service)
        let spy = StateSpy(vm.state)
        vm.loadHeroes()
        XCTAssertEqual(spy.values, [.empty,
                                    .empty
        ])
    }    
}
