//
//  Created by Pablo Balduz on 12/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    func start()
}
