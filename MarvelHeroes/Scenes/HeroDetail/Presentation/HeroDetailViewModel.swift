//
//  Created by Pablo Balduz on 10/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import RxSwift
import RxCocoa
import MarvelHeroesKit

struct HeroDetailViewModel {
    
    enum State: Equatable {
        case empty
        case detail(HeroDetail)
        
        var detail: HeroDetail? {
            switch self {
            case .empty:
                return nil
            case let .detail(detail):
                return detail
            }
        }
    }
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    private let load = PublishRelay<Void>()
    private let service: HeroesService
    private let heroID: Int
    
    var state: Observable<State> {
        Observable.merge([
            .just(.empty),
            loadContent()
        ])
    }
    
    init(heroID: Int, service: HeroesService) {
        self.service = service
        self.heroID = heroID
    }
    
    func loadDetail() {
        load.accept(())
    }
    
    // MARK: - Private
    
    private func loadContent() -> Observable<State> {
        load
            .flatMap { [isLoading, service, heroID] _ -> Observable<HeroDetail> in
                isLoading.accept(true)
                return service.fetchHeroDetail(id: heroID).asObservable()
            }.map { [isLoading] in
                isLoading.accept(false)
                return .detail($0)
            }
    }
}
