//
//  UserActivityHelper.swift
//  iosSearchApp
//
//  Created by Camilo Cadena on 9/30/15.
//  Copyright © 2015 Camilo Cadena. All rights reserved.
//

import UIKit

struct UserActivityConstants {
    static let kcityNameKey = "cityName"
    static let kcityImageDataKey = "cityImageData"
    static let kcityDescriptionKey = "cityDescription"
}

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
        //NSUserActivity to be used
        let imageData: NSData = UIImagePNGRepresentation(item.iconPhoto)!
        
        let activity = NSUserActivity(activityType: "com.ccadena.iosSearchApp.cityDetail")
        
        activity.userInfo = [UserActivityConstants.kcityNameKey: item.titleText, UserActivityConstants.kcityImageDataKey: imageData, UserActivityConstants.kcityDescriptionKey: item.descriptionText]
        
        activity.title = item.titleText
        var keywords = item.titleText.componentsSeparatedByString(" ")
        keywords.append(item.descriptionText)
        activity.keywords = Set(keywords)
        activity.eligibleForHandoff = false
        activity.eligibleForSearch = true
        //activity.eligibleForPublicIndexing = true
        //activity.expirationDate = NSDate()
        
        activity.addUserInfoEntriesFromDictionary([UserActivityConstants.kcityNameKey: item.titleText, UserActivityConstants.kcityImageDataKey: imageData, UserActivityConstants.kcityDescriptionKey: item.descriptionText])
        
        return activity
    }

}
