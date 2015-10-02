//
//  Item.swift
//  iosSearchApp
//
//  Created by Camilo Cadena on 9/28/15.
//  Copyright © 2015 Camilo Cadena. All rights reserved.
//

import UIKit

struct itemKey {
    static let titleTextKey = "titleTextKey"
    static let iconPhotoKey = "iconPhoto"
    static let descriptionTextKey = "descriptionText"
    static let indexKey = "index"
}

class Item: NSObject, NSCoding {

    var titleText: String
    var iconPhoto: UIImage?
    var descriptionText: String
    var index: Int
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("items")
    
    init?(titleText: String, iconPhoto: UIImage, descriptionText: String, index: Int) {
        self.titleText = titleText
        self.descriptionText = descriptionText
        self.iconPhoto = iconPhoto
        self.index = index
        
        super.init()
        
        // Fail if title or description are missing
        if (titleText.isEmpty || descriptionText.isEmpty) {
            return nil
        }
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(titleText, forKey: itemKey.titleTextKey)
        aCoder.encodeObject(iconPhoto, forKey: itemKey.iconPhotoKey)
        aCoder.encodeObject(descriptionText, forKey: itemKey.descriptionTextKey)
        aCoder.encodeObject(index, forKey:itemKey.indexKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let titleText = aDecoder.decodeObjectForKey(itemKey.titleTextKey) as! String
        let iconPhoto = aDecoder.decodeObjectForKey(itemKey.iconPhotoKey) as? UIImage
        let descriptionText = aDecoder.decodeObjectForKey(itemKey.descriptionTextKey) as! String
        let index = aDecoder.decodeObjectForKey(itemKey.indexKey) as! Int
        
        self.init(titleText: titleText, iconPhoto: iconPhoto!, descriptionText: descriptionText, index: index)
    }
}
