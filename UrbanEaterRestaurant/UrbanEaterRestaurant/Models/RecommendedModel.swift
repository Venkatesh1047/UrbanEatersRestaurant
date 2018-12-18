//
//	RecommendedModel.swift
//
//	Create by Vamsi Gonaboyina on 17/12/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class RecommendedModel{

	var code : Int!
	var data : [RecommendedData]!
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
		data = [RecommendedData]()
		let dataArray = json["data"].arrayValue
		for dataJson in dataArray{
			let value = RecommendedData(fromJson: dataJson)
			data.append(value)
		}
		message = json["message"].string ?? ""
		name = json["name"].string ?? ""
		statusCode = json["statusCode"].int ?? 0
	}

}


class RecommendedCustomize{
    
    var id : String!
    var name : String!
    var price : Int!
    var status : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].string ?? ""
        name = json["name"].string ?? ""
        price = json["price"].int ?? 0
        status = json["status"].int ?? 0
    }
    
}

class RecommendedData{
    
    var available : Int!
    var avatar : String!
    var categoryId : [String]!
    var customize : [RecommendedCustomize]!
    var defaultField : Int!
    var descriptionField : String!
    var id : String!
    var mainCategoryId : String!
    var name : String!
    var offer : RecommendedOffer!
    var offerStatus : Int!
    var popular : Int!
    var price : Int!
    var recommended : Int!
    var restaurantId : String!
    var slug : String!
    var status : Int!
    var subCategoryId : [String]!
    var timings : RecommendedTiming!
    var vorousType : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
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
        customize = [RecommendedCustomize]()
        let customizeArray = json["customize"].arrayValue
        for customizeJson in customizeArray{
            let value = RecommendedCustomize(fromJson: customizeJson)
            customize.append(value)
        }
        defaultField = json["default"].int ?? 0
        descriptionField = json["description"].string ?? ""
        id = json["id"].string ?? ""
        mainCategoryId = json["mainCategoryId"].string ?? ""
        name = json["name"].string ?? ""
        let offerJson = json["offer"]
        if !offerJson.isEmpty{
            offer = RecommendedOffer(fromJson: offerJson)
        }
        offerStatus = json["offerStatus"].int ?? 0
        popular = json["popular"].int ?? 0
        price = json["price"].int ?? 0
        recommended = json["recommended"].int ?? 0
        restaurantId = json["restaurantId"].string ?? ""
        slug = json["slug"].string ?? ""
        status = json["status"].int ?? 0
        subCategoryId = [String]()
        let subCategoryIdArray = json["subCategoryId"].arrayValue
        for subCategoryIdJson in subCategoryIdArray{
            subCategoryId.append(subCategoryIdJson.string ?? "")
        }
        let timingsJson = json["timings"]
        if !timingsJson.isEmpty{
            timings = RecommendedTiming(fromJson: timingsJson)
        }
        vorousType = json["vorousType"].int ?? 0
    }
    
}


class RecommendedOffer{
    
    var status : Int!
    var type : String!
    var value : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        status = json["status"].int ?? 0
        type = json["type"].string ?? ""
        value = json["value"].int ?? 0
    }
    
}


class RecommendedTiming{
    
    var endAt : String!
    var startAt : String!
    var status : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        endAt = json["endAt"].string ?? ""
        startAt = json["startAt"].string ?? ""
        status = json["status"].int ?? 0
    }
    
}
