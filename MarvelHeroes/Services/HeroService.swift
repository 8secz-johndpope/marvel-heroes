//
//  Created by Pablo Balduz on 09/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import RxSwift
import MarvelHeroesKit

protocol HeroesService {
    func fetchHeros(query: String?) -> Single<[Hero]>
    func fetchHeroDetail(id: Int) -> Single<HeroDetail>
}

extension MarvelAPIClient: HeroesService {
    
    func fetchHeros(query: String?) -> Single<[Hero]> {
        fetchHeroes(query: query)
    }
    
    func fetchHeroDetail(id: Int) -> Single<HeroDetail> {
        fetchHeroDetail(heroID: id)
    }
}
