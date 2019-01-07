//
//	NotificationsModel.swift
//
//	Create by Vamsi Gonaboyina on 31/12/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class NotificationsModel{

	var notifications : [Notify]!

	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		notifications = [Notify]()
		let notificationsArray = json["Notifications"].arrayValue.reversed()
		for notificationsJson in notificationsArray{
			let value = Notify(fromJson: notificationsJson)
			notifications.append(value)
		}
	}
}

class Notify{
    
    var aps:NotificationAPS!
    var data:NotificationData!
    var orderId:String!
    var key:String!
    var timeStamp:Int!
    var date:String!
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let apsObject = json["aps"].exists() ? json["aps"] : JSON.init([""])
        if !apsObject.isEmpty{
            aps = NotificationAPS(apsObject)
        }
        let dataObject = json["data"].string ?? ""
        data = NotificationData(dataObject)
        orderId = json["orderId"].string ?? ""
        key = json["key"].string ?? ""
        timeStamp = data.timeStamp ?? 0
        date = timeStamp.toDouble.dateString
    }
}

class NotificationAPS {
    var alert:NotificationAlert!
    var sound:Int!
    init(_ json:JSON!) {
        if json.isEmpty{
            return
        }
        let alertObject = json["alert"].exists() ? json["alert"] : JSON.init([""])
        if !alertObject.isEmpty{
            self.alert = NotificationAlert(alertObject)
        }
        sound = json["sound"].int ?? 0
    }
}

class NotificationAlert{
    var title:String!
    var body:String!
    
    init(_ json:JSON!) {
        if json.isEmpty{
            return
        }
        self.title = json["title"].string ?? ""
        self.body = json["body"].string ?? ""
    }
}

class NotificationData{
    var timeStamp:Int!
    var orderId:String!
    init(_ json:String!) {
        if json.isEmpty{
            self.timeStamp = ((Date().timeIntervalSinceNow)/1000).toInt
            self.orderId = ""
            return
        }
        let object = JSON.init(json.toJSON() as Any)
        self.timeStamp = ((object["timeStamp"].double ?? 0.0)/1000).toInt
        self.orderId = object["orderId"].string ?? ""
    }
}
