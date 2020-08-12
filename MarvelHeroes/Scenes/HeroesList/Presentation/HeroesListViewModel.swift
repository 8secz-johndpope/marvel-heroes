//
//  Created by Pablo Balduz on 09/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import RxSwift
import RxCocoa
import MarvelHeroesKit

struct HeroesListViewModel {
    
    enum State: Equatable {
        case list([CellViewModel])
        case empty
    }
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    let filterText = PublishRelay<String?>()
    
    private let service: HeroesService
    
    init(service: HeroesService) {
        self.service = service
    }
    
    var state: Observable<State> {
        Observable.merge([
            .just(.empty),
            filter()
        ])
    }
    
    func loadHeroes() {
        filterText.accept(nil)
    }
    
    // MARK: - Private
        
    private func filter() -> Observable<State> {
        filterText
            .distinctUntilChanged()
            .flatMap { [isLoading, service] query -> Observable<[Hero]> in
                isLoading.accept(true)
                let searchQuery = query == "" ? nil : query
                return service.fetchHeros(query: searchQuery).asObservable()
            }.map { [isLoading] in
                isLoading.accept(false)
                return $0.isEmpty ? .empty : .list($0.map(CellViewModel.init))
            }
    }
}
