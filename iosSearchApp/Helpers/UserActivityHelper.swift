//
//  UserActivityHelper.swift
//  iosSearchApp
//
//  Created by Camilo Cadena on 9/30/15.
//  Copyright © 2015 Camilo Cadena. All rights reserved.
//

import UIKit

private let _sharedInstance = UserActivityHelper()

class UserActivityHelper: NSObject {
    
    class var sharedInstance: UserActivityHelper {
        struct Static {
            static var instance: UserActivityHelper?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = UserActivityHelper()
        }
        
        return Static.instance!
    }
    
     func indexItemForSearch(item: Item) -> NSUserActivity
    {
        //Creates NSUserActivity to be used
        let imageData: NSData = UIImageJPEGRepresentation(item.iconPhoto, 0)!
        
        let activity = NSUserActivity(activityType: "com.ccadena.iosSearchApp.cityDetail")
        activity.userInfo = ["cityName": item.titleText, "cityImageData": imageData, "cityDescription": item.descriptionText]
        activity.title = item.titleText
        var keywords = item.titleText.componentsSeparatedByString(" ")
        keywords.append(item.descriptionText)
        activity.keywords = Set(keywords)
        activity.eligibleForHandoff = false
        activity.eligibleForSearch = true
        //activity.eligibleForPublicIndexing = true
        //activity.expirationDate = NSDate()
        
        activity.addUserInfoEntriesFromDictionary(["cityName": item.titleText, "cityImageData": imageData, "cityDescription": item.descriptionText])
        
        return activity
    }

}
