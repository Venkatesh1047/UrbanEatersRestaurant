//
//	TableOrderModel.swift
//
//	Create by Vamsi Gonaboyina on 12/12/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class TableOrderModel{

	var code : Int!
	var data : [TableOrderData]!
	var message : String!
	var name : String!
	var statusCode : Int!
    var new : [TableOrderData]!
    var scheduled : [TableOrderData]!
    var completed : [TableOrderData]!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		code = json["code"].int ?? 0
		data = [TableOrderData]()
        new = [TableOrderData]()
        scheduled = [TableOrderData]()
        completed = [TableOrderData]()
		let dataArray = json["data"].arrayValue
		for dataJson in dataArray{
			let value = TableOrderData(fromJson: dataJson)
			data.append(value)
            if value.status == 1{
                new.append(value)
            }else if value.status == 2{
                scheduled.append(value)
            }else{
                completed.append(value)
            }
		}
		message = json["message"].string ?? ""
		name = json["name"].string ?? ""
		statusCode = json["statusCode"].int ?? 0
	}

}

class TableOrderAddres{
    
    var city : String!
    var country : String!
    var fulladdress : String!
    var line1 : String!
    var line2 : String!
    var state : String!
    var zipcode : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        city = json["city"].string ?? ""
        country = json["country"].string ?? ""
        fulladdress = json["fulladdress"].string ?? ""
        line1 = json["line1"].string ?? ""
        line2 = json["line2"].string ?? ""
        state = json["state"].string ?? ""
        zipcode = json["zipcode"].string ?? ""
    }
    
}

class TableOrderContact{
    
    var email : String!
    var name : String!
    var phone : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        email = json["email"].string ?? ""
        name = json["name"].string ?? ""
        phone = json["phone"].string ?? ""
    }
    
}

class TableOrderData{
    
    var address : TableOrderAddres!
    var bookedDate : String!
    var bookedOn : Int!
    var code : Int!
    var contact : TableOrderContact!
    var customerId : String!
    var history : TableOrderHistory!
    var id : String!
    var loc : TableOrderLoc!
    var orderId : String!
    var personCount : Int!
    var restaurantId : String!
    var restaurantIdData : TableOrderRestaurantIdData!
    var reviewIdData : TableOrderReviewIdData!
    var reviewStatus : Int!
    var startAt : String!
    var startTime : String!
    var status : Int!
    var statusText : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let addressJson = json["address"]
        if !addressJson.isEmpty{
            address = TableOrderAddres(fromJson: addressJson)
        }
        bookedDate = json["bookedDate"].string ?? ""
        bookedOn = json["bookedOn"].int ?? 0
        code = json["code"].int ?? 0
        let contactJson = json["contact"]
        if !contactJson.isEmpty{
            contact = TableOrderContact(fromJson: contactJson)
        }
        customerId = json["customerId"].string ?? ""
        let historyJson = json["history"]
        if !historyJson.isEmpty{
            history = TableOrderHistory(fromJson: historyJson)
        }
        id = json["id"].string ?? ""
        let locJson = json["loc"]
        if !locJson.isEmpty{
            loc = TableOrderLoc(fromJson: locJson)
        }
        orderId = json["orderId"].string ?? ""
        personCount = json["personCount"].int ?? 0
        restaurantId = json["restaurantId"].string ?? ""
        let restaurantIdDataJson = json["restaurantIdData"]
        if !restaurantIdDataJson.isEmpty{
            restaurantIdData = TableOrderRestaurantIdData(fromJson: restaurantIdDataJson)
        }
        let reviewIdDataJson = json["reviewIdData"]
        if !reviewIdDataJson.isEmpty{
            reviewIdData = TableOrderReviewIdData(fromJson: reviewIdDataJson)
        }
        reviewStatus = json["reviewStatus"].int ?? 0
        startAt = json["startAt"].string ?? ""
        startTime = json["startTime"].string ?? ""
        status = json["status"].int ?? 0
        statusText = json["statusText"].string ?? ""
    }
    
}

class TableOrderHistory{
    
    var bookedAt : String!
    var operationAt : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        bookedAt = json["bookedAt"].string ?? ""
        operationAt = json["operationAt"].string ?? ""
    }
    
}

class TableOrderLoc{
    
    var lat : Float!
    var lng : Float!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        lat = json["lat"].float ?? 0.0
        lng = json["lng"].float ?? 0.0
    }
    
}

class TableOrderRestaurantIdData{
    
    var address : TableOrderAddres!
    var avatar : String!
    var id : String!
    var loc : TableOrderLoc!
    var logo : String!
    var name : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let addressJson = json["address"]
        if !addressJson.isEmpty{
            address = TableOrderAddres(fromJson: addressJson)
        }
        avatar = json["avatar"].string ?? ""
        id = json["id"].string ?? ""
        let locJson = json["loc"]
        if !locJson.isEmpty{
            loc = TableOrderLoc(fromJson: locJson)
        }
        logo = json["logo"].string ?? ""
        name = json["name"].string ?? ""
    }
    
}

class TableOrderReviewIdData{
    
    var customerId : String!
    var descriptionField : String!
    var id : String!
    var orderId : String!
    var restaurantId : String!
    var review : Float!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        customerId = json["customerId"].string ?? ""
        descriptionField = json["description"].string ?? ""
        id = json["id"].string ?? ""
        orderId = json["orderId"].string ?? ""
        restaurantId = json["restaurantId"].string ?? ""
        review = json["review"].float ?? 0.0
    }
    
}

