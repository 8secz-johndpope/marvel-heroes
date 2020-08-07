//
//  Created by Pablo Balduz on 07/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

func stubResponse(for fileName: String) -> Data {
    let path = Bundle(identifier: "com.pbalduz.MarvelHeroesKit")!.path(forResource: fileName, ofType: "json")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    return data
}
