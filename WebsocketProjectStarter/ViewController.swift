//
//  ViewController.swift
//  WebsocketProjectStarter
//
//  Created by timzaak on 15/8/21.
//  Copyright (c) 2015年 very.util. All rights reserved.
//

import UIKit
import SwiftyJSON
class ViewController: UIViewController {


    
    @IBAction func connect(sender: AnyObject) {
        WebsocketWrapper.shared.connect()
    }
    
    @IBAction func disconnect(sender: AnyObject) {
        WebsocketWrapper.shared.disConnect()
    }
    @IBAction func push(sender: AnyObject) {
//        {"p0":"customer.login","p2":"z5216558","p1":13716379973
            let _cmd = "customer.login"
        let p1:JSON = "login"
        let p2:JSON  = "pass"
        
        WebsocketWrapper.shared.send(JReq(cmd:_cmd,params:[p1,p2])).map{(json:JSON)->Void in
            log.info("success to analyze " + json.stringValue)
            return ()
        }
    }
    @IBAction func register(sender: AnyObject) {
        //TODO:
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

