//
//  Created by Pablo Balduz on 13/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import UIKit

class ColumnFlowLayout: UICollectionViewFlowLayout {
    
    var columnCount: Int = 1 {
        didSet {
            if columnCount != oldValue {
                self.invalidateLayout()
            }
        }
    }
        
    var containerWidth: CGFloat = 0.0 {
        didSet {
            if containerWidth != oldValue {
                self.invalidateLayout()
            }
        }
    }
    
    convenience init(containerWidth: CGFloat) {
        self.init()
        
        self.containerWidth = containerWidth
        self.minimumLineSpacing = 10
        self.minimumInteritemSpacing = 10
        self.configLayout()
    }
    
    func configLayout() {
        let itemWidth = (containerWidth / CGFloat(columnCount)) - 50
        self.itemSize = CGSize(width: itemWidth, height: 100)
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        self.configLayout()
    }
}
