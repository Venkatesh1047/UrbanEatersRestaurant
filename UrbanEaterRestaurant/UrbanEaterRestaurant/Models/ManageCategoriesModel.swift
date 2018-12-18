//
//	ManageCategoriesModel.swift
//
//	Create by Vamsi Gonaboyina on 17/12/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class ManageCategoriesModel{

	var code : Int!
	var data : [ManageCategoriesData]!
	var message : String!
	var name : String!
	var statusCode : Int!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		code = json["code"].int ?? 0
		data = [ManageCategoriesData]()
		let dataArray = json["data"].arrayValue
		for dataJson in dataArray{
			let value = ManageCategoriesData(fromJson: dataJson)
			data.append(value)
		}
		message = json["message"].string ?? ""
		name = json["name"].string ?? ""
		statusCode = json["statusCode"].int ?? 0
	}

}


class ManageCategoriesData{
    
    var categoryId : String!
    var itemList : [ManageCategoriesItemList]!
    var name : String!
    var restaurantId : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        categoryId = json["categoryId"].string ?? ""
        itemList = [ManageCategoriesItemList]()
        let itemListArray = json["itemList"].arrayValue
        for itemListJson in itemListArray{
            let value = ManageCategoriesItemList(fromJson: itemListJson)
            itemList.append(value)
        }
        name = json["name"].string ?? ""
        restaurantId = json["restaurantId"].string ?? ""
    }
    
}


class ManageCategoriesItemList{
    
    var available : Int!
    var avatar : String!
    var itemId : String!
    var name : String!
    var price : Int!
    var restaurantId : String!
    var status : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        available = json["available"].int ?? 0
        avatar = json["avatar"].string ?? ""
        itemId = json["itemId"].string ?? ""
        name = json["name"].string ?? ""
        price = json["price"].int ?? 0
        restaurantId = json["restaurantId"].string ?? ""
        status = json["status"].int ?? 0
    }
    
}
