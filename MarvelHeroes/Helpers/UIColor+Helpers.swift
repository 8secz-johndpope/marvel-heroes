//
//  Created by Pablo Balduz on 13/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
}
