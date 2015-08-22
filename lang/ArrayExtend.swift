//
// Created by timzaak on 15/8/21.
// Copyright (c) 2015 very.util. All rights reserved.
//

import Foundation

extension Array {

    func mapWithIndex<U>(transform: (Int,T) -> U) -> [U]{
        var i = -1
        return self.map{ value in
            i+=1
            return transform(i,value)
        }
    }
    func zipWithIndex()->[(Int,T)]{
        var i = -1
        return self.map{ value in
            i+=1
            return (i,value)
        }
    }

//    func toMap<K, U>()->Dictionary<K,U>{
//        return Dictionary(self)
//    }
//  TODO: how to get the map method out of Array
//    func mapWithIndex<U>(transform: (Int,T) -> U) -> [U]{
//        return map(enumerate(self),transform)
//    }
}
