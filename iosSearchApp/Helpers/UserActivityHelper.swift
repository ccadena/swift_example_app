//
//  UserActivityHelper.swift
//  iosSearchApp
//
//  Created by Camilo Cadena on 9/30/15.
//  Copyright © 2015 Camilo Cadena. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

struct UserActivityConstants {
    static let kcityNameKey = "cityName"
    static let kcityImageDataKey = "cityImageData"
    static let kcityDescriptionKey = "cityDescription"
    static let kcityIndexKey = "cityIndex"
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
        let activity = NSUserActivity(activityType: GlobalConstants.kActivityType)
        
        activity.userInfo = [UserActivityConstants.kcityNameKey: item.titleText, UserActivityConstants.kcityDescriptionKey: item.descriptionText, UserActivityConstants.kcityIndexKey: item.index]
        
        activity.title = item.titleText
        var keywords = item.titleText.componentsSeparatedByString(" ")
        keywords.append(item.descriptionText)
        activity.keywords = Set(keywords)
        activity.eligibleForHandoff = false
        activity.eligibleForSearch = true
        //activity.eligibleForPublicIndexing = true
        //activity.expirationDate = NSDate()
        
        activity.addUserInfoEntriesFromDictionary([UserActivityConstants.kcityNameKey: item.titleText, UserActivityConstants.kcityDescriptionKey: item.descriptionText, UserActivityConstants.kcityIndexKey: item.index])
        
        if GlobalConstants.kEnrichUserActivityWithCS{
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
            attributeSet.title = item.titleText
            attributeSet.contentDescription = item.descriptionText
            activity.contentAttributeSet = attributeSet
        }
        
        return activity
    }

}
