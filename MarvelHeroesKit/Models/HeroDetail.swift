//
//  Created by Pablo Balduz on 10/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

public struct HeroDetail: Decodable {
    public let id: Int
    public let name: String
    public let description: String
    public let thumbnail: Thumbnail
    
    // for testing purposes
    public init(id: Int, name: String, description: String, thumbnail: Thumbnail) {
        self.id = id
        self.name = name
        self.description = description
        self.thumbnail = thumbnail
    }
}

extension HeroDetail: Equatable {
    public static func == (lhs: HeroDetail, rhs: HeroDetail) -> Bool {
        return lhs.id == rhs.id
    }
}
