//
//  Created by Pablo Balduz on 09/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base : UIActivityIndicatorView {
    public var run : Binder<Bool> {
        return Binder(self.base) { spinner, shouldRun in
            if shouldRun {
                spinner.startAnimating()
                spinner.alpha = 1
            } else {
                spinner.stopAnimating()
                spinner.alpha = 0
            }
        }
    }
}
