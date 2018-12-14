//
//	RestaurantLoginModel.swift
//
//	Create by Vamsi Gonaboyina on 11/12/2018


import Foundation 
import SwiftyJSON

class RestaurantLoginModel{

	var code : Int!
	var data : RestaurantData!
	var message : String!
	var name : String!
	var statusCode : Int!


	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		code = json["code"].int ?? 0
		let dataJson = json["data"]
		if !dataJson.isEmpty{
			data = RestaurantData(fromJson: dataJson)
		}
		message = json["message"].string ?? ""
		name = json["name"].string ?? ""
		statusCode = json["statusCode"].int ?? 0
	}

}

class RestaurantData{
    
    var ctdAt : String!
    var ctdOn : Int!
    var deviceToken : String!
    var id : String!
    var loginId : String!
    var role : Int!
    var sessionId : String!
    var subId : String!
    var through : String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        ctdAt = json["ctdAt"].string ?? ""
        ctdOn = json["ctdOn"].int ?? 0
        deviceToken = json["deviceToken"].string ?? ""
        id = json["id"].string ?? ""
        loginId = json["loginId"].string ?? ""
        role = json["role"].int ?? 0
        sessionId = json["sessionId"].string ?? ""
        subId = json["subId"].string ?? ""
        through = json["through"].string ?? ""
    }
    
}

