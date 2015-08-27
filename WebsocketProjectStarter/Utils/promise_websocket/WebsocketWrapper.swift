//
//  WebsocketWrapper.swift
//  WebsocketProjectStarter
//
//  Created by timzaak on 15/8/21.
//  Copyright (c) 2015年 very.util. All rights reserved.
//

import Foundation
import Starscream
import SwiftyJSON
import BrightFutures


class WebsocketWrapper :WebSocketDelegate {

    typealias PubFunc = JSON->Void
    typealias Runable = Void->Void
    
    class var shared: WebsocketWrapper {
        dispatch_once(&Inner.token) {
            Inner.instance = WebsocketWrapper()
        }
        return Inner.instance!
    }
    struct Inner {
        static var instance: WebsocketWrapper?
        static var token: dispatch_once_t = 0
    }
    private let _websocket :WebSocket
    
    let WEBSOCKET_DISPATCH_QUEUE = dispatch_queue_create("timzaak_websocket_queue", DISPATCH_QUEUE_SERIAL)

    private var _dic = [String:Promise<JSON,WSReturnError>]()
    
    private var _pubSubDic = [String:[PubFunc]]()

    private var needRetry = true

    private var afterConnected:Runable?


    init(){
        _websocket = WebSocket(url:NSURL(scheme:WSSCHEME,host:HOST,path:WSPATH)!)
        _websocket.delegate = self;
        
    }
    init(url:NSURL){
        _websocket = WebSocket(url:url)
        _websocket.delegate = self;
        
    }

    func websocketDidConnect(socket: WebSocket){
        log.debug("websocket connect")
        self.afterConnected?()
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?){
        log.error(error?.debugDescription)
        if(self.needRetry){
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime,WEBSOCKET_DISPATCH_QUEUE,{
                    self.connect()
            })
        }
        
    }
    func websocketDidReceiveMessage(socket: WebSocket, text: String){
        if(text.size() > 3){
            log.debug("[receive=]"+text)
            let json = JSON(data:text.dataUsingEncoding(NSUTF8StringEncoding)!)
            if let uid = json["h"]["m"].string {
                dispatch_async(WEBSOCKET_DISPATCH_QUEUE){
                    if let error=json["r"].dictionaryValue["e"] {
                        let returnError = WSReturnError(error:error)
                        self._dic[uid]?.failure(returnError)
                    }else{
                        self._dic[uid]!.success(json["r"])
                    }
                    self._dic.removeValueForKey(uid)
                }
            }else{
                if let sign = json["e"].string{
                    dispatch_async(WEBSOCKET_DISPATCH_QUEUE){
                        if let arrayFun = self._pubSubDic[sign] {
                            for fun in arrayFun{
                                fun(json)
                            }
                        }else{
                            log.info("skip info:" + text)
                        }
                    }
                }else{
                    log.info("skip info:" + text)
                }
            }
        }
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData){
        //TODO:
    }
    func connect(){
        self.needRetry = true
        self._websocket.connect()
    }

    func connect(onComplete:Runable){
        self.afterConnected = onComplete
        self.connect()
    }
    
    func disConnect(){
        self.needRetry = false
        self._websocket.disconnect()
    }
    
    
    private func send(text_info:String){
        log.debug("[sender=]" + text_info)
        _websocket.writeString(text_info)
    }

    private func send(json_info:JSON){
        if let text = json_info.rawString() {
            self.send(text)
        }else{
            log.error("push \(json_info) error,please check the request")
        }
    }
    
    func send(jReq:JReq)->Future<JSON,WSReturnError>{
            let (uid,json) = jReq.toJSON()
            let promise = Promise<JSON,WSReturnError>()
            dispatch_async(WEBSOCKET_DISPATCH_QUEUE){
                self._dic[uid] = promise
                self.send(json)
            }
            return promise.future
    }
    
    
    func register(event:String,block:JSON -> Void){
        dispatch_async(WEBSOCKET_DISPATCH_QUEUE){
            if let arrayFunc = self._pubSubDic[event] {
                var _arrayFuncRadming = arrayFunc
                _arrayFuncRadming.append(block)
                self._pubSubDic[event] = _arrayFuncRadming
            }else{
                self._pubSubDic[event] = [block]
            }
        }
    }
    
    func disRegister(event:String){
        dispatch_async(WEBSOCKET_DISPATCH_QUEUE){
            self._pubSubDic.removeValueForKey(event)
        }
    }

}

