//
//  CityDetailViewController.swift
//  iosSearchApp
//
//  Created by Camilo Cadena on 9/29/15.
//  Copyright © 2015 Camilo Cadena. All rights reserved.
//

import UIKit

class CityDetailViewController: UIViewController {
    
    @IBOutlet var cityImage: UIImageView!
    @IBOutlet var cityName: UILabel!
    @IBOutlet var cityDescription: UITextView!
    var item: Item?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
            
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if self.cityName != nil && self.cityDescription != nil {
            
            if let item = item
            {
                self.cityName.text = item.titleText
                self.cityDescription.text = item.descriptionText
                self.cityImage.image = item.iconPhoto
                
                self.userActivity = UserActivityHelper.sharedInstance.indexItemForSearch(item)
                self.userActivity!.becomeCurrent()
                
                updateUserActivityState(self.userActivity!)
                
            }
        }
    }
    
    override func updateUserActivityState(activity: NSUserActivity) {
        
        let imageData: NSData = UIImageJPEGRepresentation(self.cityImage.image!, 0)!
        
        activity.addUserInfoEntriesFromDictionary([UserActivityConstants.kcityNameKey: self.cityName.text! as String, UserActivityConstants.kcityImageDataKey: imageData, UserActivityConstants.kcityDescriptionKey: self.cityDescription.text as String])
        super.updateUserActivityState(activity)
    }
}
