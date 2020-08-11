//
//  Created by Pablo Balduz on 10/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import RxSwift

class StateSpy<T: Equatable> {
    private(set) var values = [T]()
    private let disposeBag = DisposeBag()
    
    init(_ observable: Observable<T>) {
        observable.subscribe(onNext: { [weak self] value in
            self?.values.append(value)
        }).disposed(by: disposeBag)
    }
}
