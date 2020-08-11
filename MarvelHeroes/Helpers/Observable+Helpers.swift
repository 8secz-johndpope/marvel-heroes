//
//  Created by Pablo Balduz on 12/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import RxSwift

extension Observable where Element == HeroDetailViewModel.State {
    
    func filterDetailState() -> Observable<HeroDetailViewModel.State> {
        self.compactMap { state in
            switch state {
            case .detail:
                return state
            default:
                return nil
            }
        }
    }
}
