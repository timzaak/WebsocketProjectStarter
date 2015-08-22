//
// Created by timzaak on 15/8/21.
// Copyright (c) 2015 very.util. All rights reserved.
//

import Foundation
import XCGLogger


let log: XCGLogger = {
    let log = XCGLogger.defaultInstance()
    log.setup(logLevel: .Debug, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil, fileLogLevel: .Debug)

    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy hh:mma"
    dateFormatter.locale = NSLocale.currentLocale()
    log.dateFormatter = dateFormatter
    return log
}()