//
//	NotificationsModel.swift
//
//	Create by Vamsi Gonaboyina on 31/12/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class NotificationsModel{

	var notifications : [Notifications]!

	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		notifications = [Notifications]()
		let notificationsArray = json["Notifications"].arrayValue
		for notificationsJson in notificationsArray{
			let value = Notifications(fromJson: notificationsJson)
			notifications.append(value)
		}
	}
}

class Notifications{
    
    var body : String!
    var date : String!
    var orderId : String!
    var status : Int!
    var title : String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        body = json["body"].string ?? ""
        date = json["date"].string ?? ""
        orderId = json["orderId"].string ?? ""
        status = json["status"].int ?? 0
        title = json["title"].string ?? ""
    }
}
