//
//  Created by Pablo Balduz on 07/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

public struct Hero: Decodable {
    public let id: Int
    public let name: String
    public let description: String
    public let thumbnail: Thumbnail
    
    // for testing purposes
    public init(id: Int, name: String, description: String, thumbnail: (String, String)) {
        self.id = id
        self.name = name
        self.description = description
        self.thumbnail = Thumbnail(path: thumbnail.0, extension: thumbnail.1)
    }
}

public struct Thumbnail: Decodable {
    public let path: String
    public let `extension`: String
}
