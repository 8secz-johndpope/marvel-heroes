//
//  Created by Pablo Balduz on 09/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import MarvelHeroesKit
import Differentiator

struct CellViewModel: Equatable {
    let hero: Hero
    
    init(_ hero: Hero) {
        self.hero = hero
    }
    
    static func == (lhs: CellViewModel, rhs: CellViewModel) -> Bool {
        lhs.hero.id == rhs.hero.id
    }
}

extension CellViewModel: IdentifiableType {
    var identity: Int {
        return hero.id
    }
}
