//
//  Created by Pablo Balduz on 09/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import UIKit

extension UIScene {
    var isRunningTests: Bool {
        guard NSClassFromString("XCTest") == nil else {
            return true
        }
        return false
    }
}
