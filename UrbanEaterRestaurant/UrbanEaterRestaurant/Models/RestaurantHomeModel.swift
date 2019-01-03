//
//	RestaurantHomeModel.swift
//
//	Create by Vamsi Gonaboyina on 12/12/2018


import Foundation 
import SwiftyJSON

class RestaurantHomeModel{

	var code : Int!
	var data : RestaurantHomeData!
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
		let dataJson = json["data"]
		if !dataJson.isEmpty{
			data = RestaurantHomeData(fromJson: dataJson)
		}
		message = json["message"].string ?? ""
		name = json["name"].string ?? ""
		statusCode = json["statusCode"].int ?? 0
	}

}

class RestaurantHomeAddres{
    
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

class RestaurantHomeBookTableTiming{
    
    var maxPersonCount : Int!
    var totalTableCount : Int!
    var weekDay : RestaurantHomeWeekDay!
    var weekEnd : RestaurantHomeWeekDay!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        maxPersonCount = json["maxPersonCount"].int ?? 0
        totalTableCount = json["totalTableCount"].int ?? 0
        let weekDayJson = json["weekDay"]
        if !weekDayJson.isEmpty{
            weekDay = RestaurantHomeWeekDay(fromJson: weekDayJson)
        }
        let weekEndJson = json["weekEnd"]
        if !weekEndJson.isEmpty{
            weekEnd = RestaurantHomeWeekDay(fromJson: weekEndJson)
        }
    }
    
}

class RestaurantHomeCommission{
    
    var admin : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        admin = json["admin"].int ?? 0
    }
    
}

class RestaurantHomeCuisineIdData{
    
    var id : String!
    var name : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].string ?? ""
        name = json["name"].string ?? ""
    }
    
}

class RestaurantHomeCustomize{
    
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

class RestaurantHomeData{
    
    var about : String!
    var address : RestaurantHomeAddres!
    var areaId : String!
    var areaName : String!
    var available : Int!
    var avatar : String!
    var banners : [String]!
    var bookTableAvailable : Int!
    var bookTableStatus : Int!
    var bookTableTimings : RestaurantHomeBookTableTiming!
    var cityId : String!
    var cityName : String!
    var code : String!
    var commission : RestaurantHomeCommission!
    var cuisineId : [String]!
    var cuisineIdData : [RestaurantHomeCuisineIdData]!
    var deliveryTime : Int!
    var docId : [String]!
    var earningIdData : [RestaurantHomeEarningIdData]!
    var emailId : String!
    var exclusiveStatus : Int!
    var featured : Int!
    var foodIdData : [RestaurantHomeFoodIdData]!
    var id : String!
    var licence : RestaurantHomeLicence!
    var loc : RestaurantHomeLoc!
    var logo : String!
    var mainCategoryIdData : [RestaurantHomeMainCategoryIdData]!
    var name : String!
    var offer : RestaurantHomeOffer!
    var offerStatus : Int!
    var perCapita : String!
    var phone : RestaurantHomePhone!
    var quickDeliveryStatus : Int!
    var reviewIdData : [RestaurantHomeReviewIdData]!
    var statIdData : RestaurantHomeStatIdData!
    var status : Int!
    var timeZone : String!
    var timings : RestaurantHomeTiming!
    var userName : String!
    var verified : Int!
    var vorousType : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        about = json["about"].string ?? ""
        let addressJson = json["address"]
        if !addressJson.isEmpty{
            address = RestaurantHomeAddres(fromJson: addressJson)
        }
        areaId = json["areaId"].string ?? ""
        areaName = json["areaName"].string ?? ""
        available = json["available"].int ?? 0
        avatar = json["avatar"].string ?? ""
        banners = [String]()
        let bannersArray = json["banners"].arrayValue
        for bannersJson in bannersArray{
            banners.append(bannersJson.string ?? "")
        }
        bookTableAvailable = json["bookTableAvailable"].int ?? 0
        bookTableStatus = json["bookTableStatus"].int ?? 0
        let bookTableTimingsJson = json["bookTableTimings"]
        if !bookTableTimingsJson.isEmpty{
            bookTableTimings = RestaurantHomeBookTableTiming(fromJson: bookTableTimingsJson)
        }
        cityId = json["cityId"].string ?? ""
        cityName = json["cityName"].string ?? ""
        code = json["code"].string ?? ""
        let commissionJson = json["commission"]
        if !commissionJson.isEmpty{
            commission = RestaurantHomeCommission(fromJson: commissionJson)
        }
        cuisineId = [String]()
        let cuisineIdArray = json["cuisineId"].arrayValue
        for cuisineIdJson in cuisineIdArray{
            cuisineId.append(cuisineIdJson.string ?? "")
        }
        cuisineIdData = [RestaurantHomeCuisineIdData]()
        let cuisineIdDataArray = json["cuisineIdData"].arrayValue
        for cuisineIdDataJson in cuisineIdDataArray{
            let value = RestaurantHomeCuisineIdData(fromJson: cuisineIdDataJson)
            cuisineIdData.append(value)
        }
        deliveryTime = json["deliveryTime"].int ?? 0
        docId = [String]()
        let docIdArray = json["docId"].arrayValue
        for docIdJson in docIdArray{
            docId.append(docIdJson.string ?? "")
        }
        earningIdData = [RestaurantHomeEarningIdData]()
        let earningIdDataArray = json["earningIdData"].arrayValue
        for earningIdDataJson in earningIdDataArray{
            let value = RestaurantHomeEarningIdData(fromJson: earningIdDataJson)
            earningIdData.append(value)
        }
        emailId = json["emailId"].string ?? ""
        exclusiveStatus = json["exclusiveStatus"].int ?? 0
        featured = json["featured"].int ?? 0
        foodIdData = [RestaurantHomeFoodIdData]()
        let foodIdDataArray = json["foodIdData"].arrayValue
        for foodIdDataJson in foodIdDataArray{
            let value = RestaurantHomeFoodIdData(fromJson: foodIdDataJson)
            foodIdData.append(value)
        }
        id = json["id"].string ?? ""
        let licenceJson = json["licence"]
        if !licenceJson.isEmpty{
            licence = RestaurantHomeLicence(fromJson: licenceJson)
        }
        let locJson = json["loc"]
        if !locJson.isEmpty{
            loc = RestaurantHomeLoc(fromJson: locJson)
        }
        logo = json["logo"].string ?? ""
        mainCategoryIdData = [RestaurantHomeMainCategoryIdData]()
        let mainCategoryIdDataArray = json["mainCategoryIdData"].arrayValue
        for mainCategoryIdDataJson in mainCategoryIdDataArray{
            let value = RestaurantHomeMainCategoryIdData(fromJson: mainCategoryIdDataJson)
            mainCategoryIdData.append(value)
        }
        name = json["name"].string ?? ""
        let offerJson = json["offer"]
        if !offerJson.isEmpty{
            offer = RestaurantHomeOffer(fromJson: offerJson)
        }
        offerStatus = json["offerStatus"].int ?? 0
        perCapita = json["perCapita"].string ?? ""
        let phoneJson = json["phone"]
        if !phoneJson.isEmpty{
            phone = RestaurantHomePhone(fromJson: phoneJson)
        }
        quickDeliveryStatus = json["quickDeliveryStatus"].int ?? 0
        reviewIdData = [RestaurantHomeReviewIdData]()
        let reviewIdDataArray = json["reviewIdData"].arrayValue
        for reviewIdDataJson in reviewIdDataArray{
            let value = RestaurantHomeReviewIdData(fromJson: reviewIdDataJson)
            reviewIdData.append(value)
        }
        let statIdDataJson = json["statIdData"]
        if !statIdDataJson.isEmpty{
            statIdData = RestaurantHomeStatIdData(fromJson: statIdDataJson)
        }
        status = json["status"].int ?? 0
        timeZone = json["timeZone"].string ?? ""
        let timingsJson = json["timings"]
        if !timingsJson.isEmpty{
            timings = RestaurantHomeTiming(fromJson: timingsJson)
        }
        userName = json["userName"].string ?? ""
        verified = json["verified"].int ?? 0
        vorousType = json["vorousType"].int ?? 0
    }
    
}

class RestaurantHomeEarningIdData{
    
    var billingStatus : Int!
    var date : Int!
    var dateString : String!
    var id : String!
    var orderCount : Int!
    var orderId : [String]!
    var restaurantId : String!
    var earnAmount : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        earnAmount = json["earnAmount"].int ?? 0
        billingStatus = json["billingStatus"].int ?? 0
        date = json["date"].int ?? 0
        dateString = json["dateString"].string ?? ""
        id = json["id"].string ?? ""
        orderCount = json["orderCount"].int ?? 0
        orderId = [String]()
        let orderIdArray = json["orderId"].arrayValue
        for orderIdJson in orderIdArray{
            orderId.append(orderIdJson.string ?? "")
        }
        restaurantId = json["restaurantId"].string ?? ""
    }
    
}

class RestaurantHomeFood{
    
    var available : Int!
    var popular : Int!
    var recommended : Int!
    var total : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        available = json["available"].int ?? 0
        popular = json["popular"].int ?? 0
        recommended = json["recommended"].int ?? 0
        total = json["total"].int ?? 0
    }
    
}

class RestaurantHomeFoodIdData{
    
    var available : Int!
    var avatar : String!
    var categoryId : [String]!
    var customize : [RestaurantHomeCustomize]!
    var descriptionField : String!
    var id : String!
    var mainCategoryId : String!
    var name : String!
    var offer : RestaurantHomeOffer!
    var offerStatus : Int!
    var popular : Int!
    var price : Int!
    var restaurantId : String!
    var subCategoryId : [String]!
    var vorousType : Int!
    var recommended : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        recommended = json["recommended"].int ?? 0
        available = json["available"].int ?? 0
        avatar = json["avatar"].string ?? ""
        categoryId = [String]()
        let categoryIdArray = json["categoryId"].arrayValue
        for categoryIdJson in categoryIdArray{
            categoryId.append(categoryIdJson.string ?? "")
        }
        customize = [RestaurantHomeCustomize]()
        let customizeArray = json["customize"].arrayValue
        for customizeJson in customizeArray{
            let value = RestaurantHomeCustomize(fromJson: customizeJson)
            customize.append(value)
        }
        descriptionField = json["description"].string ?? ""
        id = json["id"].string ?? ""
        mainCategoryId = json["mainCategoryId"].string ?? ""
        name = json["name"].string ?? ""
        let offerJson = json["offer"]
        if !offerJson.isEmpty{
            offer = RestaurantHomeOffer(fromJson: offerJson)
        }
        offerStatus = json["offerStatus"].int ?? 0
        popular = json["popular"].int ?? 0
        price = json["price"].int ?? 0
        restaurantId = json["restaurantId"].string ?? ""
        subCategoryId = [String]()
        let subCategoryIdArray = json["subCategoryId"].arrayValue
        for subCategoryIdJson in subCategoryIdArray{
            subCategoryId.append(subCategoryIdJson.string ?? "")
        }
        vorousType = json["vorousType"].int ?? 0
    }
    
}

class RestaurantHomeLicence{
    
    var endAt : String!
    var endOn : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        endAt = json["endAt"].string ?? ""
        endOn = json["endOn"].int ?? 0
    }
    
}

class RestaurantHomeLoc{
    
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

class RestaurantHomeMainCategoryIdData{
    
    var id : String!
    var level : Int!
    var name : String!
    var restaurantId : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].string ?? ""
        level = json["level"].int ?? 0
        name = json["name"].string ?? ""
        restaurantId = json["restaurantId"].string ?? ""
    }
    
}

class RestaurantHomeOffer{
    
    var status : Int!
    var type : String!
    var value : Int!
    var maxDiscountAmount : Int!
    var minAmount : Int!
    
    
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
        maxDiscountAmount = json["maxDiscountAmount"].int ?? 0
        minAmount = json["minAmount"].int ?? 0
    }
    
}

class RestaurantHomeOrder{
    
    var accepted : Int!
    var completed : Int!
    var ordered : Int!
    var totalAccepted : Int!
    var totalCompleted : Int!
    var totalOrdered : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        accepted = json["accepted"].int ?? 0
        completed = json["completed"].int ?? 0
        ordered = json["ordered"].int ?? 0
        totalAccepted = json["totalAccepted"].int ?? 0
        totalCompleted = json["totalCompleted"].int ?? 0
        totalOrdered = json["totalOrdered"].int ?? 0
    }
    
}

class RestaurantHomePhone{
    
    var code : String!
    var number : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        code = json["code"].string ?? ""
        number = json["number"].string ?? ""
    }
    
}

class RestaurantHomeRating{
    
    var average : Float!
    var totalCount : Int!
    var totalValue : Float!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        average = json["average"].float ?? 0.0
        totalCount = json["totalCount"].int ?? 0
        totalValue = json["totalValue"].float ?? 0.0
    }
    
}

class RestaurantHomeReviewIdData{
    
    var customerId : String!
    var descriptionField : String!
    var id : String!
    var orderId : String!
    var restaurantId : String!
    var review : Int!
    
    
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
        review = json["review"].int ?? 0
    }
    
}

class RestaurantHomeStatIdData{
    
    var food : RestaurantHomeFood!
    var id : String!
    var order : RestaurantHomeOrder!
    var rating : RestaurantHomeRating!
    var restaurantId : String!
    var review : RestaurantHomeRating!
    

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let foodJson = json["food"].exists() ? json["food"] : JSON.init([""])
        if !foodJson.isEmpty{
            food = RestaurantHomeFood(fromJson: foodJson)
        }
        id = json["id"].string ?? ""
        let orderJson = json["order"].exists() ? json["order"] : JSON.init([""])
        if !orderJson.isEmpty{
            order = RestaurantHomeOrder(fromJson: orderJson)
        }
        let ratingJson = json["rating"].exists() ? json["rating"] : JSON.init([""])
        if !ratingJson.isEmpty{
            rating = RestaurantHomeRating(fromJson: ratingJson)
        }
        restaurantId = json["restaurantId"].string ?? ""
        let reviewJson = json["review"].exists() ? json["review"] : JSON.init([""])
        if !reviewJson.isEmpty{
            review = RestaurantHomeRating(fromJson: reviewJson)
        }
    }
    
}


class RestaurantHomeTiming{
    
    var weekDay : RestaurantHomeWeekDay!
    var weekEnd : RestaurantHomeWeekDay!
    

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let weekDayJson = json["weekDay"].exists() ? json["weekDay"] : JSON.init([""])
        if !weekDayJson.isEmpty{
            weekDay = RestaurantHomeWeekDay(fromJson: weekDayJson)
        }
        let weekEndJson = json["weekEnd"].exists() ? json["weekEnd"] : JSON.init([""])
        if !weekEndJson.isEmpty{
            weekEnd = RestaurantHomeWeekDay(fromJson: weekEndJson)
        }
    }
    
}


class RestaurantHomeWeekDay{
    
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
