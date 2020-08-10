//
//  Created by Pablo Balduz on 09/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import RxSwift
import MarvelHeroesKit

protocol HeroesService {
    func fetchHeros(query: String?) -> Single<[Hero]>
}

extension MarvelAPIClient: HeroesService {
    
    func fetchHeros(query: String?) -> Single<[Hero]> {
        fetchHeroes(query: query)
    }
}
