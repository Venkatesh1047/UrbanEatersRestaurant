//
//  Constants.swift
//  UrbanEaterRestaurant
//
//  Created by Nagaraju on 31/10/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

import Foundation

let X_SESSION_ID        = "x-session-id"
let X_API_KEY           = "x-api-key"
let SOCKET_SESSION_ID   = "sessionId"
let SUB_ID              = "subId"
let ROLE                = "role"
let RESTAURANT          = "RESTAURANT"
let AUTHENTICATION      = "authentication"
let SOCKET_ORDER_STATUS = "socket_order_status"
let ERROR               = "error"
let RESULT              = "result"
let CONNECTION_DEFAULT  = "connection"
let CONNECTION          = "connection"
let DISCONNECT          = "disconnect"
let DATA                = "data"
let ORDER_ID                          = "orderId"
let KEY                               = "key"
let NOTIFICATION_STATUS               = "Notification_Status"
let NOTIFICATION_APPDELEGATE          = "Notification_Appdelegate"
let NOTIFICATION_SOCKETS              = "Notification_Sockets"

// Sockets
let GET_RESTAURANT_ORDERS             =  "socket_get_restaurant_orders"
let GET_ORDERS_BY_RESTAURANT_ID       = "socket_get_orders_by_restaurant_id"
let GET_ORDERS_TABLE_BY_RESTAURANT_ID = "socket_get_orders_table_by_restaurant_id"

class Constants{
    static let sharedInstance = Constants()
    static let BASEURL_IMAGE                = "http://13.233.109.143:1234"                  // Production
    static let BASEURL_IMAGE1              = "http://192.168.100.88:1234"                 // Developement
    static let BaseUrl                                  = "http://13.233.109.143:1234/api/v1/"   // Production
    static let BaseUrl1                                = "http://192.168.100.88:1234/api/v1/"    // Developement
    
    public struct urls {
        
        static let loginURL                                                 = "\(BaseUrl)restaurant/login"
        static let logoutURL                                               = "\(BaseUrl)restaurant/logout/by-id"
        static let changePasswordURL                            = "\(BaseUrl)restaurant/update-password"
        static let orderHistoryURL                                    = "\(BaseUrl)order/by-restaurant"
        static let UpdaterRestaurantData                       = "\(BaseUrl)restaurant/update/by-id"
        static let getRestaurantDataURL                         = "\(BaseUrl)restaurant/by-id"
        static let getFoodOrdersURL                               = "\(BaseUrl)order/by-restaurant"
        static let getTableOrdersURL                               = "\(BaseUrl)order-table/by-restaurant"
        static let restaurantAllOrdersURL                        = "\(BaseUrl)restaurant/all/orders"
        static let FoodOrderUpdateReqURL                   = "\(BaseUrl)order/update/by-res-id"
        static let TableUpdateByResID                             = "\(BaseUrl)order-table/update/by-res-id"
        static let TableOrderUpdatetReqURL                 = "\(BaseUrl)order-table/update/by-res-id"
        static let ForgotPassword                                      = "\(BaseUrl)restaurant/forgot-password"
        static let UpdateNewPassword                            = "\(BaseUrl)restaurant/change-password"
        static let RecommendedItems                             = "\(BaseUrl)food/by-restaurant"
        static let UpdateRecommendedItems                = "\(BaseUrl)food/make/recommended"
        static let RecommendedItemDelete                   = "\(BaseUrl)food/remove/recommended"
        static let ManageCaegories                                  = "\(BaseUrl)food/by-restaurant-raw"
        static let CategoryFoodItemDelete                     = "\(BaseUrl)food/delete/by-id"
        static let CategoryFoodItemUpdate                    = "\(BaseUrl)food/change/available"
        static let EarningsSummary                                   = "\(BaseUrl)order/earnings/by-restaurant"
        static let TableBookingHistory                              = "\(BaseUrl)order-table/by-restaurant"
        static let VerifyOTP                                                  = "\(BaseUrl)service-otp/validate"
        static let VerifyOTP_Restaurant                             = "\(BaseUrl)restaurant/verify-restaurant-email"
        static let ResendOTP                                               = "\(BaseUrl)/service-otp/resend"
        static let Create_Category                                      = "\(BaseUrl)/category/create"
        static let Create_Food                                             = "\(BaseUrl)/food/create"
        static let Food_Update_ID                                     = "\(BaseUrl)/food/update/by-id"
        static let Category_Delete_By_ID                        = "\(BaseUrl)/category/delete/by-id"
    }
    public struct ApiParams  {
        static let Staus_Code   = "statusCode"
        static let Message      = "message"
        static let User_Details = "userDetails"
        static let Code         = "code"
    }
}

// MARK : - Toast Messages
public struct ToastMessages {
    static let mobile_number_empty = "Mobile number can't be empty"
    static let password_empty      = "Password can't be empty"
    static let  Unable_To_Sign_UP  = "Unable to register now, Please try again...😞"
    static let Check_Internet_Connection   = "Please check internet connection"
    static let Some_thing_went_wrong       = "Something went wrong...🙃"
    static let Invalid_Credentials         = "Invalid credentials...🤔"
    static let Success                     = "Success...😀"
    static let Email_Address_Is_Empty      =  "Email address can't empty"
    static let Invalid_Email               =  "Invalid Email Address"
    static let Invalid_FirstName           =  "Invalid Username"
    static let Invalid_Number              =  "Invalid Mobile Number"
    static let Invalid_Password            =  "Password must contains min 6 character"
    static let Please_Wait                 =  "Please wait..."
    static let Password_Missmatch          =  "Confirm Password doesnot match with the New Password...😟"
    static let Logout                      =  "Logout Successfully...🤚"
    static let Invalid_Latitude            = "Invalid latitude"
    static let Invalid_Longitude           = "Invalid longitude"
    static let Invalid_Address             = "Invalid Address"
    static let Invalid_SelectedAddressType = "Please choose address type"
    static let Invalid_Strong_Password     = "Password should be at least 6 characters, which Contain At least 1 uppercase, 1 lower case, 1 Numeric digit."
    static let Invalid_OTP                 =  "Invalid OTP"
    static let No_Data_Available           = "No data available..."
    static let WEEKDAY_START_TIME_EMPTY    = "Week-day start time can't empty"
    static let WEEKDAY_END_TIME_EMPTY      = "Week-day end time can't empty"
    static let WEEKEND_START_TIME_EMPTY    = "Week-end start time can't empty"
    static let WEEKEND_END_TIME_EMPTY      = "Week-end end time can't empty"
    static let DELIVARY_TIME_EMPTY         = "Delivary time can't empty"
    static let Session_Expired             = "Your session has been expired.Please login again"
    static let START_TIME_EMPTY    = "Start time can't empty"
    static let END_TIME_EMPTY      = "End time can't empty"
}
