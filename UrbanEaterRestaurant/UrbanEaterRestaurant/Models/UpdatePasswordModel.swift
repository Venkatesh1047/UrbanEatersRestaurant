//
//	UpdatePasswordModel.swift
//
//	Create by Vamsi Gonaboyina on 14/12/2018


import Foundation 
import SwiftyJSON

class UpdatePasswordModel{

	var code : Int!
	var data : UpdatePasswordData!
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
			data = UpdatePasswordData(fromJson: dataJson)
		}
		message = json["message"].string ?? ""
		name = json["name"].string ?? ""
		statusCode = json["statusCode"].int ?? 0
	}
}

class UpdatePasswordData{
    
    var id : String!
    var otp : String!
    var referenceNumber : String!
    var subId : String!
    var through : String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].string ?? ""
        otp = json["otp"].string ?? ""
        referenceNumber = json["referenceNumber"].string ?? ""
        subId = json["subId"].string ?? ""
        through = json["through"].string ?? ""
    }
}
