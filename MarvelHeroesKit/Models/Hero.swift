//
//  Created by Pablo Balduz on 07/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

public struct Hero: Decodable {
    public let id: Int
    public let name: String
    public let description: String
    public let thumbnail: Thumbnail
}

public struct Thumbnail: Decodable {
    public let path: String
    public let `extension`: String
}
