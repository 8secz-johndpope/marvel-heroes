//
//  Created by Pablo Balduz on 12/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import UIKit

protocol ReusableCell: class {
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    static var reuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UICollectionView {
    
    func registerCell<T: UICollectionViewCell>(_ type: T.Type) where T: ReusableCell {
        register(type, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueCollectionViewCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReusableCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Seems like \(T.self) cell type is not registered")
        }
        return cell
    }
}
