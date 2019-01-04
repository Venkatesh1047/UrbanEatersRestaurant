//
//	FoodOrderModelFoodOrder.swift
//
//	Create by Vamsi Gonaboyina on 12/12/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class FoodOrderModel{

	var code : Int!
	var data : [FoodOrderModelData]!
	var message : String!
	var name : String!
	var statusCode : Int!
    var new : [FoodOrderModelData]!
    var scheduled : [FoodOrderModelData]!
    var completed : [FoodOrderModelData]!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		code = json["code"].int ?? 0
		data = [FoodOrderModelData]()
        new = [FoodOrderModelData]()
        scheduled = [FoodOrderModelData]()
        completed = [FoodOrderModelData]()
        let dataArray = json["data"].arrayValue.sorted { (json1, json2) -> Bool in
            return json1["ctdAt"].string ?? "" > json2["ctdAt"].string ?? ""
        }
		for dataJson in dataArray{
			let value = FoodOrderModelData(fromJson: dataJson)
			data.append(value)
            if value.order[0].status == 1{
                new.append(value)
            }else if value.order[0].status == 2{
                scheduled.append(value)
            }else {
                completed.append(value)
            }
		}
		message = json["message"].string ?? ""
		name = json["name"].string ?? ""
		statusCode = json["statusCode"].int ?? 0
	}

}

class FoodOrderModelAddon{
    
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

class FoodOrderModelAddres{
    
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

class FoodOrderModelBilling{
    
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

class FoodOrderModelCustomize{
    
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

class FoodOrderModelData{
    
    var addons : [FoodOrderModelAddon]!
    var address : FoodOrderModelAddres!
    var billing : FoodOrderModelBilling!
    var code : String!
    var ctdAt : String!
    var customerId : String!
    var discounts : FoodOrderModelDiscount!
    var driverId : String!
    var driverIdData : FoodOrderModelDriverIdData!
    var history : FoodOrderModelHistory!
    var id : String!
    var items : [FoodOrderModelItem]!
    var loc : FoodOrderModelLoc!
    var order : [FoodOrderModelOrder]!
    var orderAddressId : String!
    var orderDate : String!
    var orderDateString : String!
    var orderId : String!
    var orderOn : Int!
    var payment : FoodOrderModelPayment!
    var paymentStatus : Int!
    var ratingStatus : Int!
    var restaurantId : [String]!
    var status : Int!
    var statusText : String!
    var transactionId : String!
    
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        addons = [FoodOrderModelAddon]()
        let addonsArray = json["addons"].arrayValue
        for addonsJson in addonsArray{
            let value = FoodOrderModelAddon(fromJson: addonsJson)
            addons.append(value)
        }
        let addressJson = json["address"]
        if !addressJson.isEmpty{
            address = FoodOrderModelAddres(fromJson: addressJson)
        }
        let billingJson = json["billing"]
        if !billingJson.isEmpty{
            billing = FoodOrderModelBilling(fromJson: billingJson)
        }
        code = json["code"].string ?? ""
        ctdAt = json["ctdAt"].string ?? ""
        customerId = json["customerId"].string ?? ""
        let discountsJson = json["discounts"]
        if !discountsJson.isEmpty{
            discounts = FoodOrderModelDiscount(fromJson: discountsJson)
        }
        driverId = json["driverId"].string ?? ""
        let driverIdDataJson = json["driverIdData"]
        if !driverIdDataJson.isEmpty{
            driverIdData = FoodOrderModelDriverIdData(fromJson: driverIdDataJson)
        }
        let historyJson = json["history"]
        if !historyJson.isEmpty{
            history = FoodOrderModelHistory(fromJson: historyJson)
        }
        id = json["id"].string ?? ""
        items = [FoodOrderModelItem]()
        let itemsArray = json["items"].arrayValue
        for itemsJson in itemsArray{
            let value = FoodOrderModelItem(fromJson: itemsJson)
            items.append(value)
        }
        let locJson = json["loc"]
        if !locJson.isEmpty{
            loc = FoodOrderModelLoc(fromJson: locJson)
        }
        order = [FoodOrderModelOrder]()
        let orderArray = json["order"].arrayValue
        for orderJson in orderArray{
            let value = FoodOrderModelOrder(fromJson: orderJson)
            order.append(value)
        }
        orderAddressId = json["orderAddressId"].string ?? ""
        orderDate = json["orderDate"].string ?? ""
        orderDateString = json["orderDateString"].string ?? ""
        orderId = json["orderId"].string ?? ""
        orderOn = json["orderOn"].int ?? 0
        let paymentJson = json["payment"]
        if !paymentJson.isEmpty{
            payment = FoodOrderModelPayment(fromJson: paymentJson)
        }
        paymentStatus = json["paymentStatus"].int ?? 0
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

class FoodOrderModelDiscount{
    
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

class FoodOrderModelHistory{
    
    var allocatedAt : String!
    var deliveredAt : String!
    var orderedAt : String!
    var pickedAt : String!
    var reachedAt : String!
    var rejectedAt : String!
    var acceptedAt : String!

    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        allocatedAt = json["allocatedAt"].string ?? ""
        deliveredAt = json["deliveredAt"].string ?? ""
        orderedAt = json["orderedAt"].string ?? ""
        pickedAt = json["pickedAt"].string ?? ""
        reachedAt = json["reachedAt"].string ?? ""
        rejectedAt = json["rejectedAt"].string ?? ""
        acceptedAt = json["acceptedAt"].string ?? ""
    }
    
}

class FoodOrderModelItem{
    
    var customize : FoodOrderModelCustomize!
    var finalPrice : Int!
    var instruction : String!
    var itemId : String!
    var name : String!
    var offer : FoodOrderModelOffer!
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
        let customizeJson = json["customize"]
        if !customizeJson.isEmpty{
            customize = FoodOrderModelCustomize(fromJson: customizeJson)
        }
        finalPrice = json["finalPrice"].int ?? 0
        instruction = json["instruction"].string ?? ""
        itemId = json["itemId"].string ?? ""
        name = json["name"].string ?? ""
        let offerJson = json["offer"].exists() ? json["offer"] : JSON.init([""])
        if !offerJson.isEmpty{
            offer = FoodOrderModelOffer(fromJson: offerJson)
        }
        offerStatus = json["offerStatus"].int ?? 0
        price = json["price"].int ?? 0
        quantity = json["quantity"].int ?? 0
        restaurantId = json["restaurantId"].string ?? ""
        vorousType = json["vorousType"].int ?? 0
    }
    
}

class FoodOrderModelLoc{
    
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

class FoodOrderModelOffer{
    
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

class FoodOrderModelOrder{
    
    var billing : FoodOrderModelBilling!
    var code : String!
    var history : FoodOrderModelHistory!
    var instruction : String!
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
        let billingJson = json["billing"].exists() ? json["billing"] : JSON.init([""])
        if !billingJson.isEmpty{
            billing = FoodOrderModelBilling(fromJson: billingJson)
        }
        code = json["code"].string ?? ""
        let historyJson = json["history"].exists() ? json["history"] : JSON.init([""])
        if !historyJson.isEmpty{
            history = FoodOrderModelHistory(fromJson: historyJson)
        }
        instruction = json["instruction"].string ?? ""
        restaurantId = json["restaurantId"].string ?? ""
        status = json["status"].int ?? 0
        statusText = json["statusText"].string ?? ""
        subOrderId = json["subOrderId"].string ?? ""
    }
    
}

class FoodOrderModelPayment{
    
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

class FoodOrderModelDriverIdData{
    
    var accuracy : Float!
    var address : FoodOrderModelAddres!
    var bearing : Float!
    var emailId : String!
    var id : String!
    var loc : FoodOrderModelLoc!
    var mobileId : String!
    var name : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        accuracy = json["accuracy"].float ?? 0.0
        let addressJson = json["address"]
        if !addressJson.isEmpty{
            address = FoodOrderModelAddres(fromJson: addressJson)
        }
        bearing = json["bearing"].float ?? 0.0
        emailId = json["emailId"].string ?? ""
        id = json["id"].string ?? ""
        let locJson = json["loc"]
        if !locJson.isEmpty{
            loc = FoodOrderModelLoc(fromJson: locJson)
        }
        mobileId = json["mobileId"].string ?? ""
        name = json["name"].string ?? ""
    }
    
}
