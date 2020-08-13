//
//  Created by Pablo Balduz on 13/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

// Based on PointFree's talk about UI styling

precedencegroup SingleTypeComposition {
    associativity: right
}

infix operator <>: SingleTypeComposition

func <> <A: AnyObject>(f: @escaping (A) -> Void, g: @escaping (A) -> Void) -> (A) -> Void {
    return { a in
        f(a)
        g(a)
    }
}
