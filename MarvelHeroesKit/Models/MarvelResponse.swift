//
//  Created by Pablo Balduz on 07/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

struct MarvelResponse<T: Decodable>: Decodable {
    private let data: MarvelDataContainer<T>
    
    var results: [T] {
        data.results
    }
}

struct MarvelDataContainer<T: Decodable>: Decodable {
    let results: [T]
}
