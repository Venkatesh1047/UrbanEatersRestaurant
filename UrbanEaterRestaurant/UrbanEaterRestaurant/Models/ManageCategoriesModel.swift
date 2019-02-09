//
//	ManageCategoriesModel.swift
//
//	Create by Vamsi Gonaboyina on 7/2/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class ManageCategoriesModel{

	var code : Int!
	var data : [ManageCategoriesData]!
	var message : String!
	var name : String!
	var statusCode : Int!

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
    var categoryId : [String]!
    var defaultField : Int!
    var descriptionField : String!
    var itemId : String!
    var mainCategoryId : String!
    var name : String!
    var nextAvailableTime : String!
    var offer : ManageCategoriesOffer!
    var offerStatus : Int!
    var popular : Int!
    var price : Int!
    var recommended : Int!
    var restaurantId : String!
    var status : Int!
    var subCategoryId : [String]!
    var timings : ManageCategoriesTiming!
    var vorousType : Int!
    
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        available = json["available"].int ?? 0
        avatar = json["avatar"].string ?? ""
        categoryId = [String]()
        let categoryIdArray = json["categoryId"].arrayValue
        for categoryIdJson in categoryIdArray{
            categoryId.append(categoryIdJson.string ?? "")
        }
        defaultField = json["default"].int ?? 0
        descriptionField = json["description"].string ?? ""
        itemId = json["itemId"].string ?? ""
        mainCategoryId = json["mainCategoryId"].string ?? ""
        name = json["name"].string ?? ""
        nextAvailableTime = json["nextAvailableTime"].string ?? ""
        let offerJson = json["offer"]
        if !offerJson.isEmpty{
            offer = ManageCategoriesOffer(fromJson: offerJson)
        }
        offerStatus = json["offerStatus"].int ?? 0
        popular = json["popular"].int ?? 0
        price = json["price"].int ?? 0
        recommended = json["recommended"].int ?? 0
        restaurantId = json["restaurantId"].string ?? ""
        status = json["status"].int ?? 0
        subCategoryId = [String]()
        let subCategoryIdArray = json["subCategoryId"].arrayValue
        for subCategoryIdJson in subCategoryIdArray{
            subCategoryId.append(subCategoryIdJson.string ?? "")
        }
        let timingsJson = json["timings"]
        if !timingsJson.isEmpty{
            timings = ManageCategoriesTiming(fromJson: timingsJson)
        }
        vorousType = json["vorousType"].int ?? 0
    }
    
}

class ManageCategoriesOffer{
    
    var status : Int!
    var type : String!
    var value : Int!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        status = json["status"].int ?? 0
        type = json["type"].string ?? ""
        value = json["value"].int ?? 0
    }
    
}

class ManageCategoriesTiming{
    
    var endAt : String!
    var startAt : String!
    var status : Int!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        endAt = json["endAt"].string ?? ""
        startAt = json["startAt"].string ?? ""
        status = json["status"].int ?? 0
    }
    
}
