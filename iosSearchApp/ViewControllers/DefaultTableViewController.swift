//
//  defaultTableViewController.swift
//  iosSearchApp
//
//  Created by Camilo Cadena on 9/28/15.
//  Copyright © 2015 Camilo Cadena. All rights reserved.
//

import UIKit
import CoreSpotlight

struct GlobalConstants {
    // set it to true to activate CoreSpotlig search API and deactivate NSUserActivity API
    // false value activates NSUserActivity API
    static let kActivateCoreSpotlightAPI = false
    
    static let kCustomTableViewCellIdentifier = "ItemsTableViewCell"
    static let kShowSelectedCitySegue = "detailSelected"
    static let kShowAddCitySegue = "addCity"
    static let kActivityType = "com.ccadena.iosSearchApp.cityDetail"
}

class defaultTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var itemsArray = [Item]()
    var retrivedFromSearch = false
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let archiedItems = loadItems() {
            if archiedItems.count > itemsArray.count
            {
                itemsArray = archiedItems
                
                if(GlobalConstants.kActivateCoreSpotlightAPI)
                {
                    saveCitiesToIndex()
                }
                
                self.tableView.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
            }
            
        } else if self.itemsArray.count == 0 {
            fillItemsArray()
            
            if(GlobalConstants.kActivateCoreSpotlightAPI)
            {
                saveCitiesToIndex()
            }
            
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Initial Array load method
    
    func fillItemsArray(){
        let firtsPhoto = UIImage(named:"firstCity")!
        let firstItem = Item(titleText: "Bogotá", iconPhoto: firtsPhoto , descriptionText: "Capital", index: 0)!
        
        let secondPhoto = UIImage(named:"secondCity")!
        let secondItem = Item(titleText: "Medellín", iconPhoto: secondPhoto , descriptionText: "Capital Paisa", index: 1)!
        
        itemsArray += [firstItem, secondItem]

    }
    
    //MARK: TableView Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = GlobalConstants.kCustomTableViewCellIdentifier
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CustomTableViewCell
        
        let item = itemsArray[indexPath.row]
        cell.mainTitleLabel.text = item.titleText
        cell.descriptionLabel.text = item.descriptionText
        cell.iconView.image = item.iconPhoto
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    //MARK: Segue Method
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == GlobalConstants.kShowSelectedCitySegue
        {
            let cityDetailViewController = segue.destinationViewController as! CityDetailViewController
            
            if retrivedFromSearch
            {
                retrivedFromSearch = false
                if let retrivedItemIndex = sender as? Int
                {
                    cityDetailViewController.item = itemsArray[retrivedItemIndex]
                }
            }
            else
            {
                if let selectedCell = sender as?  CustomTableViewCell
                {
                    let indexPath = tableView.indexPathForCell(selectedCell)!
                    let selectedCity = itemsArray[indexPath.row]
                    cityDetailViewController.item = selectedCity
                }
            }
        }
        else if segue.identifier == GlobalConstants.kShowAddCitySegue
        {
            let addCityViewController = segue.destinationViewController as! AddCityViewController
            addCityViewController.itemsArray = self.itemsArray
        }
       
    }
    
    // MARK: NSCoding
    func loadItems() -> [Item]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Item.ArchiveURL.path!) as? [Item]
    }


    // MARK: NSUserActivity
    override func restoreUserActivityState(activity: NSUserActivity) {
        
        /*if let cityName = activity.userInfo?[UserActivityConstants.kcityNameKey] as? String
        {
            if let cityDescription = activity.userInfo?[UserActivityConstants.kcityDescriptionKey] as? String
            {*/
                if let cityIndex = activity.userInfo?[UserActivityConstants.kcityIndexKey] as? Int
                {
                    print("*** IOS9 SEARCHAPP ***")
                   // print("Retrived City: ",cityName,"\nDescription: ", cityDescription, "\nindex: ", cityIndex)
                    
                    retrivedFromSearch = true
                    self.performSegueWithIdentifier(GlobalConstants.kShowSelectedCitySegue, sender: cityIndex)
                }
                else if let cityIndex = activity.userInfo?["kCSSearchableItemActivityIdentifier"] as? String
                {
                    retrivedFromSearch = true
                    self.performSegueWithIdentifier(GlobalConstants.kShowSelectedCitySegue, sender: Int(cityIndex))
                }
                else{
                    let alert = UIAlertController(title: "Error", message: "Error retrieving information from userInfo:\n\(activity.userInfo)", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
           // }
        //}
    }
    
    //MARK: CoreSpotlight
    func saveCitiesToIndex() {
        
        var searchableItems = [CSSearchableItem]()
        
        for item in itemsArray {
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: "image" as String)
            attributeSet.title = item.titleText
            attributeSet.contentDescription = item.descriptionText
            attributeSet.thumbnailData = UIImagePNGRepresentation(item.iconPhoto!)
            
            let item = CSSearchableItem(uniqueIdentifier: (item.index as NSNumber).stringValue, domainIdentifier: GlobalConstants.kActivityType, attributeSet: attributeSet)
            searchableItems.append(item)
        }
        
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems(searchableItems, completionHandler: { error -> Void in
            if error != nil {
                print(error?.localizedDescription)
            }
        })
    }
    
}
