//
//  Created by Pablo Balduz on 07/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import CryptoSwift

struct MarvelAuth {
    static let publicKey = "8ab2ce9389b9bbb3f4c30a55122a61a3"
    static let privateKey = "265ee5b2aa45e1c7a69e2fd1ff5f687f49375e73"
    static func hash(ts: String) -> String {
        "\(ts + privateKey + publicKey)".md5()
    }
}
