//
//	RestaurantAllOrdersModel.swift
//
//	Create by Vamsi Gonaboyina on 13/12/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class RestaurantAllOrdersModel{

	var code : Int!
	var data : [RestaurantAllOrdersData]!
	var message : String!
	var name : String!
	var statusCode : Int!
    var new : [RestaurantAllOrdersData]!
    var scheduled : [RestaurantAllOrdersData]!
    var completed : [RestaurantAllOrdersData]!
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		code = json["code"].int ?? 0
		data = [RestaurantAllOrdersData]()
        new = [RestaurantAllOrdersData]()
        scheduled = [RestaurantAllOrdersData]()
        completed = [RestaurantAllOrdersData]()
        let dataArray = json["data"].arrayValue.sorted { (json1, json2) -> Bool in
            return json1["ctdAt"].stringValue > json2["ctdAt"].stringValue
        }
		for dataJson in dataArray{
			let value = RestaurantAllOrdersData(fromJson: dataJson)
			data.append(value)
            if value.isOrderTable {
                if value.status == 1{
                    self.new.append(value)
                }else if value.status == 2 {
                    self.scheduled.append(value)
                }else {
                    self.completed.append(value)
                }
            }else{
                if value.order[0].status == 1{
                    self.new.append(value)
                }else if value.order[0].status >= 2 && value.order[0].status < 5{
                    self.scheduled.append(value)
                }else {
                    self.completed.append(value)
                }
            }
		}
		message = json["message"].string ?? ""
		name = json["name"].string ?? ""
		statusCode = json["statusCode"].int ?? 0
	}
}


class RestaurantAllOrdersAddon{
    
    var addonId : String!
    var finalPrice : Int!
    var name : String!
    var price : Int!
    var quantity : Int!
    

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


class RestaurantAllOrdersAddres{
    
    var city : String!
    var country : String!
    var fulladdress : String!
    var line1 : String!
    var line2 : String!
    var state : String!
    var zipcode : String!
    
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

class RestaurantAllOrdersBilling{
    
    var couponDiscount : Int!
    var deliveryCharge : Int!
    var grandTotal : Float!
    var orderTotal : Int!
    var serviceTax : Int!
    

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


class RestaurantAllOrdersContact{
    
    var email : String!
    var name : String!
    var phone : String!
    

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        email = json["email"].string ?? ""
        name = json["name"].string ?? ""
        phone = json["phone"].string ?? ""
    }
}

class RestaurantAllOrdersCustomize{
    
    var customizeId : String!
    var name : String!
    var price : Int!
    

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        customizeId = json["customizeId"].string ?? ""
        name = json["name"].string ?? ""
        price = json["price"].int ?? 0
    }
}

class RestaurantAllOrdersData{
    
    var addons : [RestaurantAllOrdersAddon]!
    var address : RestaurantAllOrdersAddres!
    var billing : RestaurantAllOrdersBilling!
    var bookedDate : String!
    var bookedOn : Int!
    var code : Int!
    var contact : RestaurantAllOrdersContact!
    var customerId : String!
    var discounts : RestaurantAllOrdersDiscount!
    var driverId : String!
    var driverIdData : RestaurantAllOrdersDriverIdData!
    var history : RestaurantAllOrdersHistory!
    var id : String!
    var isOrderTable : Bool!
    var items : [RestaurantAllOrdersItem]!
    var loc : RestaurantAllOrdersLoc!
    var order : [RestaurantAllOrdersOrder]!
    var orderAddressId : String!
    var orderDate : String!
    var orderId : String!
    var orderOn : Int!
    var payment : RestaurantAllOrdersPayment!
    var personCount : Int!
    var ratingStatus : Int!
    var restaurantId : [String]!
    var restaurantIdData : [RestaurantAllOrdersRestaurantIdData]!
    var reviewStatus : Int!
    var startAt : String!
    var startTime : String!
    var status : Int!
    var statusText : String!
    var transactionId : String!
    var ctdAt :  String!
    

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        addons = [RestaurantAllOrdersAddon]()
        let addonsArray = json["addons"].arrayValue
        for addonsJson in addonsArray{
            let value = RestaurantAllOrdersAddon(fromJson: addonsJson)
            addons.append(value)
        }
        let addressJson = json["address"].exists() ? json["address"] : JSON.init([""])
        if !addressJson.isEmpty{
            address = RestaurantAllOrdersAddres(fromJson: addressJson)
        }
        let billingJson = json["billing"].exists() ? json["billing"] : JSON.init([""])
        if !billingJson.isEmpty{
            billing = RestaurantAllOrdersBilling(fromJson: billingJson)
        }
        bookedDate = json["bookedDate"].string ?? ""
        bookedOn = json["bookedOn"].int ?? 0
        code = json["code"].int ?? 0
        let contactJson = json["contact"].exists() ? json["contact"] : JSON.init([""])
        if !contactJson.isEmpty{
            contact = RestaurantAllOrdersContact(fromJson: contactJson)
        }
        customerId = json["customerId"].string ?? ""
        let discountsJson = json["discounts"].exists() ? json["discounts"] : JSON.init([""])
        if !discountsJson.isEmpty{
            discounts = RestaurantAllOrdersDiscount(fromJson: discountsJson)
        }
        driverId = json["driverId"].string ?? ""
        let driverIdDataJson = json["driverIdData"]
        if !driverIdDataJson.isEmpty{
            driverIdData = RestaurantAllOrdersDriverIdData(fromJson: driverIdDataJson)
        }
        let historyJson = json["history"].exists() ? json["history"] : JSON.init([""])
        if !historyJson.isEmpty{
            history = RestaurantAllOrdersHistory(fromJson: historyJson)
        }
        id = json["id"].string ?? ""
        isOrderTable = json["isOrderTable"].bool ?? false
        items = [RestaurantAllOrdersItem]()
        let itemsArray = json["items"].arrayValue
        for itemsJson in itemsArray{
            let value = RestaurantAllOrdersItem(fromJson: itemsJson)
            if value.restaurantId == GlobalClass.restaurantLoginModel.data.subId{
                items.append(value)
            }
        }
        let locJson = json["loc"].exists() ? json["loc"] : JSON.init([""])
        if !locJson.isEmpty{
            loc = RestaurantAllOrdersLoc(fromJson: locJson)
        }
        order = [RestaurantAllOrdersOrder]()
        let orderArray = json["order"].arrayValue
        for orderJson in orderArray{
            let value = RestaurantAllOrdersOrder(fromJson: orderJson)
            if value.restaurantId == GlobalClass.restaurantLoginModel.data.subId{
                order.append(value)
            }
        }
        orderAddressId = json["orderAddressId"].string ?? ""
        orderDate = json["orderDate"].string ?? ""
        orderId = json["orderId"].string ?? ""
        orderOn = json["orderOn"].int ?? 0
        let paymentJson = json["payment"].exists() ? json["payment"] : JSON.init([""])
        if !paymentJson.isEmpty{
            payment = RestaurantAllOrdersPayment(fromJson: paymentJson)
        }
        personCount = json["personCount"].int ?? 0
        ratingStatus = json["ratingStatus"].int ?? 0
        restaurantId = [String]()
        let restaurantIdArray = json["restaurantId"].arrayValue
        for restaurantIdJson in restaurantIdArray{
            restaurantId.append(restaurantIdJson.string ?? "")
        }
        restaurantIdData = [RestaurantAllOrdersRestaurantIdData]()
        let restaurantIdDataArray = json["restaurantIdData"].arrayValue
        for restaurantIdDataJson in restaurantIdDataArray{
            let value = RestaurantAllOrdersRestaurantIdData(fromJson: restaurantIdDataJson)
            restaurantIdData.append(value)
        }
        reviewStatus = json["reviewStatus"].int ?? 0
        startAt = json["startAt"].string ?? ""
        startTime = json["startTime"].string ?? ""
        status = json["status"].int ?? 0
        statusText = json["statusText"].string ?? ""
        transactionId = json["transactionId"].string ?? ""
        ctdAt = json["ctdAt"].string ?? ""
    }
}


class RestaurantAllOrdersDiscount{
    
    var couponId : String!
    var offerId : String!
    
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        couponId = json["couponId"].string ?? ""
        offerId = json["offerId"].string ?? ""
    }
}


class RestaurantAllOrdersHistory{
    
    var allocatedAt : String!
    var deliveredAt : String!
    var orderedAt : String!
    var pickedAt : String!
    var reachedAt : String!
    var rejectedAt : String!
    var acceptedAt : String!
    
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

class RestaurantAllOrdersItem{
    
    var customize : RestaurantAllOrdersCustomize!
    var finalPrice : Int!
    var instruction : String!
    var itemId : String!
    var name : String!
    var offer : RestaurantAllOrdersOffer!
    var offerStatus : Int!
    var price : Int!
    var quantity : Int!
    var restaurantId : String!
    var vorousType : Int!
    
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let customizeJson = json["customize"].exists() ? json["customize"] : JSON.init([""])
        if !customizeJson.isEmpty{
            customize = RestaurantAllOrdersCustomize(fromJson: customizeJson)
        }
        finalPrice = json["finalPrice"].int ?? 0
        instruction = json["instruction"].string ?? ""
        itemId = json["itemId"].string ?? ""
        name = json["name"].string ?? ""
        let offerJson = json["offer"].exists() ? json["offer"] : JSON.init([""])
        if !offerJson.isEmpty{
            offer = RestaurantAllOrdersOffer(fromJson: offerJson)
        }
        offerStatus = json["offerStatus"].int ?? 0
        price = json["price"].int ?? 0
        quantity = json["quantity"].int ?? 0
        restaurantId = json["restaurantId"].string ?? ""
        vorousType = json["vorousType"].int ?? 0
    }
}


class RestaurantAllOrdersLoc{
    
    var lat : Float!
    var lng : Float!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        lat = json["lat"].float ?? 0.0
        lng = json["lng"].float ?? 0.0
    }
}


class RestaurantAllOrdersOffer{
    
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

class RestaurantAllOrdersOrder{
    
    var billing : RestaurantAllOrdersBilling!
    var code : String!
    var history : RestaurantAllOrdersHistory!
    var instruction : String!
    var restaurantId : String!
    var status : Int!
    var statusText : String!
    var subOrderId : String!
    
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let billingJson = json["billing"].exists() ? json["billing"] : JSON.init([""])
        if !billingJson.isEmpty{
            billing = RestaurantAllOrdersBilling(fromJson: billingJson)
        }
        code = json["code"].string ?? ""
        let historyJson = json["history"].exists() ? json["history"] : JSON.init([""])
        if !historyJson.isEmpty{
            history = RestaurantAllOrdersHistory(fromJson: historyJson)
        }
        instruction = json["instruction"].string ?? ""
        restaurantId = json["restaurantId"].string ?? ""
        status = json["status"].int ?? 0
        statusText = json["statusText"].string ?? ""
        subOrderId = json["subOrderId"].string ?? ""
    }
}


class RestaurantAllOrdersPayment{
    
    var mode : String!
    var repayStatus : Int!
    var status : Int!
    var throughType : String!
    
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


class RestaurantAllOrdersRestaurantIdData{
    
    var address : RestaurantAllOrdersAddres!
    var available : Int!
    var avatar : String!
    var deliveryTime : Int!
    var id : String!
    var loc : RestaurantAllOrdersLoc!
    var logo : String!
    var name : String!
    var perCapita : String!
    
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let addressJson = json["address"].exists() ? json["address"] : JSON.init([""])
        if !addressJson.isEmpty{
            address = RestaurantAllOrdersAddres(fromJson: addressJson)
        }
        available = json["available"].int ?? 0
        avatar = json["avatar"].string ?? ""
        deliveryTime = json["deliveryTime"].int ?? 0
        id = json["id"].string ?? ""
        let locJson = json["loc"].exists() ? json["loc"] : JSON.init([""])
        if !locJson.isEmpty{
            loc = RestaurantAllOrdersLoc(fromJson: locJson)
        }
        logo = json["logo"].string ?? ""
        name = json["name"].string ?? ""
        perCapita = json["perCapita"].string ?? ""
    }
}

class RestaurantAllOrdersDriverIdData{
    
    var accuracy : Float!
    var address : RestaurantAllOrdersAddres!
    var bearing : Float!
    var emailId : String!
    var id : String!
    var loc : RestaurantAllOrdersLoc!
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
            address = RestaurantAllOrdersAddres(fromJson: addressJson)
        }
        bearing = json["bearing"].float ?? 0.0
        emailId = json["emailId"].string ?? ""
        id = json["id"].string ?? ""
        let locJson = json["loc"]
        if !locJson.isEmpty{
            loc = RestaurantAllOrdersLoc(fromJson: locJson)
        }
        mobileId = json["mobileId"].string ?? ""
        name = json["name"].string ?? ""
    }
    
}

