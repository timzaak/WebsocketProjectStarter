//
// Created by timzaak on 15/8/21.
// Copyright (c) 2015 very.util. All rights reserved.
//

import Foundation
import SwiftyJSON
//{"p0":"","p1":"","p2":""}


struct JReq {
    let cmd:String
    let params:Array<JSON>
    

    func toJSON()->(String,JSON){
        var header = ["p0":JSON(cmd)]
        let paramWithIndex = params.zipWithIndex()
        for (index,v) in params.zipWithIndex() {
            header["p"+String((index+1))]=v
        }
        let mark = generateUid()
        header["m"]=JSON(mark)
        return (mark,JSON(header))

    }
    
    private func generateUid()->String{
        return NSUUID().UUIDString
    }
    
}

