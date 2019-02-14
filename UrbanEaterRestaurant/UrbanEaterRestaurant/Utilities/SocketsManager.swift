//
//  SocketsManager.swift
//  UrbanEats
//
//  Created by Hexadots on 07/02/19.
//  Copyright © 2019 Hexadots. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON
import EZSwiftExtensions
@available(iOS 10.0, *)
@objc protocol SocketIOManagerDelegate{
    
}
let Sockets = SocketsManager.sharedInstance

class SocketsManager: NSObject {
    var Delegate:SocketIOManagerDelegate?
    var notificationmode : NSString = NSString()
    var iSSocketDisconnected:Bool=Bool()
    var iSChatSocketDisconnected:Bool=Bool()
    
    let manager = SocketManager(socketURL: URL(string: "http://13.233.109.143:1234")!, config: [.log(true), .compress, .forcePolling(true), .reconnects(true), .reconnectAttempts(-1), .secure(false), .forceWebsockets(true)])
    
    let credintials = [SOCKET_SESSION_ID : GlobalClass.restaurantLoginModel.data.sessionId!,
                                  SUB_ID : GlobalClass.restaurantLoginModel.data.subId!,
                                  ROLE : RESTAURANT]
    
    var socket:SocketIOClient!
    class var sharedInstance: SocketsManager {
        struct Singleton {
            static let instance = SocketsManager()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
        socket = manager.defaultSocket
    }
    func connectionEstablish(){
        if(socket != nil) {
            if(socket.status == .disconnected || socket.status == .notConnected) {
                //RemoveAllListener()
                socket.on(clientEvent: .connect) { (data, ack) in
                    print("..Check Socket hat_onConnection.....\(data).........")
                    self.socket.emit(AUTHENTICATION, self.credintials)
                }
                //socket?.connect()
            }else{
                self.iSSocketDisconnected=false;
                //self.CreateRoom(Nickname: Nickname);
            }
        }
    }
    func establishConnection(){
        socket?.connect()
    }
    func socketWithName(_ socketName:String, input:SocketData, completionHandler:@escaping (_ response: Any) -> ()){
        self.socket.emitWithAck(socketName, input).timingOut(after: 0) {data in
            if data.count > 0{
                let result     = data[0] as! [String:AnyObject]
                let dic        = (result[RESULT] ?? result[ERROR]) as! [String:AnyObject]
                let stautsCode = dic[Constants.ApiParams.Staus_Code] as! NSNumber
                let message    = dic[Constants.ApiParams.Message] as! String
                let code       = dic[Constants.ApiParams.Code] as! NSNumber
                if Int(exactly:stautsCode)! >= 200 && Int(exactly:stautsCode)! < 300{
                    completionHandler(dic)
                }else{
                    if Int(exactly:code)! == 1607 || Int(exactly:code)! == 1608{
                        if !TheGlobalPoolManager.isAlertDisplaying{
                            TheGlobalPoolManager.showAlertWith(message: ToastMessages.Session_Expired, singleAction: true, callback: { (success) in
                                if success!{
                                    GlobalClass.logout()
                                    if let viewCon = ez.topMostVC?.storyboard?.instantiateViewController(withIdentifier: "LoginVCID") as? LoginVC{
                                        let appdelegate = UIApplication.shared.delegate as! AppDelegate
                                        appdelegate.window!.rootViewController = viewCon
                                    }
                                }
                            })
                        }
                    }
                    Themes.sharedInstance.removeActivityView(View: (URLhandler.sharedInstance.topMostVC()?.view)!)
                }
            }
        }
    }
    func lisitenToSocketConnectionWithName(_ socketName:String, input:SocketData, completionHandler:@escaping (_ response: Any) -> ()){
    }
    func socketDisconnect(){
        socket.on(DISCONNECT){data, ack in
            //self.iSSocketDisconnected=true
            print("..Check Socket dis Connection.....\(data).........")
            self.socket?.off(CONNECTION_DEFAULT)
        }
    }
    func removeAllListener(){
        socket?.disconnect()
        socket?.removeAllHandlers()
        socket?.off(CONNECTION_DEFAULT)
    }
    func LeaveRoom(providerid : String){
        socket?.emit(DISCONNECT,self.credintials)
        self.removeAllListener()
        print("***************SOCKET DISCONNECTED******************")
    }
}
