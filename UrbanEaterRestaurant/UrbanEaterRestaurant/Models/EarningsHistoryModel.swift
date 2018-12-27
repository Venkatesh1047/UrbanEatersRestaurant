//
//	EarningsHistoryModel.swift
//
//	Create by Vamsi Gonaboyina on 17/12/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class EarningsHistoryModel{

	var code : Int!
	var data : EarningsHistoryData!
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
		let dataJson = json["data"].exists() ? json["data"] : JSON.init([""])
		if !dataJson.isEmpty{
			data = EarningsHistoryData(fromJson: dataJson)
		}
		message = json["message"].string ?? ""
		name = json["name"].string ?? ""
		statusCode = json["statusCode"].int ?? 0
	}

}

class EarningsHistoryOrderFoodData{
    
    var addons : [EarningsHistoryAddon]!
    var address : EarningsHistoryAddres!
    var billing : EarningsHistoryBilling!
    var code : Int!
    var ctdAt : String!
    var customerId : String!
    var discounts : EarningsHistoryDiscount!
    var driverId : String!
    var history : EarningsHistoryHistory!
    var id : String!
    var items : [EarningsHistoryItem]!
    var loc : EarningsHistoryLoc!
    var order : [EarningsHistoryOrder]!
    var orderAddressId : String!
    var orderDate : String!
    var orderId : String!
    var orderOn : Int!
    var payment : EarningsHistoryPayment!
    var ratingStatus : Int!
    var restaurantId : [String]!
    var status : Int!
    var statusText : String!
    var transactionId : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        addons = [EarningsHistoryAddon]()
        let addonsArray = json["addons"].arrayValue
        for addonsJson in addonsArray{
            let value = EarningsHistoryAddon(fromJson: addonsJson)
            addons.append(value)
        }
        let addressJson = json["address"].exists() ? json["address"] : JSON.init([""])
        if !addressJson.isEmpty{
            address = EarningsHistoryAddres(fromJson: addressJson)
        }
        let billingJson = json["billing"].exists() ? json["billing"] : JSON.init([""])
        if !billingJson.isEmpty{
            billing = EarningsHistoryBilling(fromJson: billingJson)
        }
        code = json["code"].int ?? 0
        ctdAt = json["ctdAt"].string ?? ""
        customerId = json["customerId"].string ?? ""
        let discountsJson = json["discounts"].exists() ? json["discounts"] : JSON.init([""])
        if !discountsJson.isEmpty{
            discounts = EarningsHistoryDiscount(fromJson: discountsJson)
        }
        driverId = json["driverId"].string ?? ""
        let historyJson = json["history"].exists() ? json["history"] : JSON.init([""])
        if !historyJson.isEmpty{
            history = EarningsHistoryHistory(fromJson: historyJson)
        }
        id = json["id"].string ?? ""
        items = [EarningsHistoryItem]()
        let itemsArray = json["items"].arrayValue
        for itemsJson in itemsArray{
            let value = EarningsHistoryItem(fromJson: itemsJson)
            if value.restaurantId == GlobalClass.restaurantLoginModel.data.subId!{
                items.append(value)
            }
        }
        let locJson = json["loc"].exists() ? json["loc"] : JSON.init([""])
        if !locJson.isEmpty{
            loc = EarningsHistoryLoc(fromJson: locJson)
        }
        order = [EarningsHistoryOrder]()
        let orderArray = json["order"].arrayValue
        for orderJson in orderArray{
            let value = EarningsHistoryOrder(fromJson: orderJson)
            if value.restaurantId == GlobalClass.restaurantLoginModel.data.subId!{
                order.append(value)
            }
        }
        orderAddressId = json["orderAddressId"].string ?? ""
        orderDate = json["orderDate"].string ?? ""
        orderId = json["orderId"].string ?? ""
        orderOn = json["orderOn"].int ?? 0
        let paymentJson = json["payment"].exists() ? json["payment"] : JSON.init([""])
        if !paymentJson.isEmpty{
            payment = EarningsHistoryPayment(fromJson: paymentJson)
        }
        ratingStatus = json["ratingStatus"].int ?? 0
        restaurantId = [String]()
        let restaurantIdArray = json["restaurantId"].arrayValue
        for restaurantIdJson in restaurantIdArray{
            restaurantId.append(restaurantIdJson.string ?? "")
        }
        status = json["status"].int ?? 0
        statusText = json["statusText"].string ?? ""
        transactionId = json["transactionId"].string ?? ""
    }
    
}


class EarningsHistoryAddon{
    
    var addonId : String!
    var finalPrice : Int!
    var name : String!
    var price : Int!
    var quantity : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        addonId = json["addonId"].string ?? ""
        finalPrice = json["finalPrice"].int ?? 0
        name = json["name"].string ?? ""
        price = json["price"].int ?? 0
        quantity = json["quantity"].int ?? 0
    }
    
}

class EarningsHistoryAddres{
    
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

class EarningsHistoryBilling{
    
    var couponDiscount : Int!
    var deliveryCharge : Int!
    var grandTotal : Float!
    var orderTotal : Int!
    var serviceTax : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        couponDiscount = json["couponDiscount"].int ?? 0
        deliveryCharge = json["deliveryCharge"].int ?? 0
        grandTotal = json["grandTotal"].float ?? 0.0
        orderTotal = json["orderTotal"].int ?? 0
        serviceTax = json["serviceTax"].int ?? 0
    }
    
}

class EarningsHistoryCustomize{
    
    var customizeId : String!
    var name : String!
    var price : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        customizeId = json["customizeId"].string ?? ""
        name = json["name"].string ?? ""
        price = json["price"].int ?? 0
    }
    
}

class EarningsHistoryData{
    
    var earningData : [EarningsHistoryEarningData]!
    var orderFoodData : [EarningsHistoryOrderFoodData]!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        earningData = [EarningsHistoryEarningData]()
        let earningDataArray = json["earningData"].arrayValue
        for earningDataJson in earningDataArray{
            let value = EarningsHistoryEarningData(fromJson: earningDataJson)
            earningData.append(value)
        }
        orderFoodData = [EarningsHistoryOrderFoodData]()
        let orderFoodDataArray = json["orderFoodData"].arrayValue
        for orderFoodDataJson in orderFoodDataArray{
            let value = EarningsHistoryOrderFoodData(fromJson: orderFoodDataJson)
            orderFoodData.append(value)
        }
    }
    
}


class EarningsHistoryDiscount{
    
    var couponId : String!
    var offerId : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        couponId = json["couponId"].string ?? ""
        offerId = json["offerId"].string ?? ""
    }
    
}

class EarningsHistoryEarningData{
    
    var restaurantId : String!
    var totalEarnAmount : Int!
    var totalOrderCount : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        restaurantId = json["restaurantId"].string ?? ""
        totalEarnAmount = json["totalEarnAmount"].int ?? 0
        totalOrderCount = json["totalOrderCount"].int ?? 0
    }
    
}

class EarningsHistoryHistory{
    
    var acceptedAt : String!
    var orderedAt : String!
    var rejectedAt : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        acceptedAt = json["acceptedAt"].string ?? ""
        orderedAt = json["orderedAt"].string ?? ""
        rejectedAt = json["rejectedAt"].string ?? ""
    }
    
}


class EarningsHistoryItem{
    
    var customize : EarningsHistoryCustomize!
    var finalPrice : Int!
    var instruction : String!
    var itemId : String!
    var name : String!
    var offer : EarningsHistoryOffer!
    var offerStatus : Int!
    var price : Int!
    var quantity : Int!
    var restaurantId : String!
    var vorousType : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let customizeJson = json["customize"].exists() ? json["customize"] : JSON.init([""])
        if !customizeJson.isEmpty{
            customize = EarningsHistoryCustomize(fromJson: customizeJson)
        }
        finalPrice = json["finalPrice"].int ?? 0
        instruction = json["instruction"].string ?? ""
        itemId = json["itemId"].string ?? ""
        name = json["name"].string ?? ""
        let offerJson = json["offer"].exists() ? json["offer"] : JSON.init([""])
        if !offerJson.isEmpty{
            offer = EarningsHistoryOffer(fromJson: offerJson)
        }
        offerStatus = json["offerStatus"].int ?? 0
        price = json["price"].int ?? 0
        quantity = json["quantity"].int ?? 0
        vorousType = json["vorousType"].int ?? 0
        restaurantId = json["restaurantId"].string ?? ""
    }
    
}

class EarningsHistoryLoc{
    
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

class EarningsHistoryOffer{
    
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

class EarningsHistoryOrder{
    
    var base : Int!
    var billing : EarningsHistoryBilling!
    var code : String!
    var history : EarningsHistoryHistory!
    var instruction : String!
    var loc : EarningsHistoryLoc!
    var restaurantId : String!
    var status : Int!
    var statusText : String!
    var subOrderId : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        base = json["base"].int ?? 0
        let billingJson = json["billing"].exists() ? json["billing"] : JSON.init([""])
        if !billingJson.isEmpty{
            billing = EarningsHistoryBilling(fromJson: billingJson)
        }
        code = json["code"].string ?? ""
        let historyJson = json["history"].exists() ? json["history"] : JSON.init([""])
        if !historyJson.isEmpty{
            history = EarningsHistoryHistory(fromJson: historyJson)
        }
        instruction = json["instruction"].string ?? ""
        let locJson = json["loc"].exists() ? json["loc"] : JSON.init([""])
        if !locJson.isEmpty{
            loc = EarningsHistoryLoc(fromJson: locJson)
        }
        restaurantId = json["restaurantId"].string ?? ""
        status = json["status"].int ?? 0
        statusText = json["statusText"].string ?? ""
        subOrderId = json["subOrderId"].string ?? ""
    }
    
}



class EarningsHistoryPayment{
    
    var mode : String!
    var repayStatus : Int!
    var status : Int!
    var throughType : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        mode = json["mode"].string ?? ""
        repayStatus = json["repayStatus"].int ?? 0
        status = json["status"].int ?? 0
        throughType = json["throughType"].string ?? ""
    }
    
}


