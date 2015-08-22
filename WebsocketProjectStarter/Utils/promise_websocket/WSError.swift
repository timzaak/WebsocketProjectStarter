//
//  WSError.swift
//  WebsocketProjectStarter
//
//  Created by timzaak on 15/8/22.
//  Copyright (c) 2015年 very.util. All rights reserved.
//

import Foundation
import BrightFutures
import SwiftyJSON
class WSReturnError:NSError{
    let errorJson:JSON
    init(error:JSON){
        self.errorJson = error
        super.init(domain:"WSError",code:0,userInfo:nil)
 }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        //super.init(coder: aDecoder)
    }
}