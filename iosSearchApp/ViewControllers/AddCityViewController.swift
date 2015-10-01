//
//  AddCityViewController.swift
//  iosSearchApp
//
//  Created by Camilo Cadena on 9/29/15.
//  Copyright © 2015 Camilo Cadena. All rights reserved.
//

import UIKit

class AddCityViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var selectButton: UIButton!
    @IBOutlet var cityName: UITextField!
    @IBOutlet var cityDescription: UITextView!
    @IBOutlet var saveButton: UIBarButtonItem!
    var cityImage: UIImage!
    let imagePicker = UIImagePickerController()
    var itemsArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSetUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -Initial Vc Setup properties
    
    func initialSetUp()
    {
        self.saveButton.enabled = false
        imagePicker.delegate = self
        self.cityDescription.text = ""
        self.cityName.text = ""
        self.cityName.placeholder = "City name"
        self.selectButton.layer.cornerRadius = self.selectButton.frame.size.width/2
        self.selectButton.clipsToBounds = true
    }

    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.cityImage = selectedImage
        self.selectButton.setBackgroundImage(self.cityImage, forState: UIControlState.Normal)
        self.selectButton.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
        self.saveButton.enabled = validateInformation()
        
        dismissViewControllerAnimated(true, completion:nil)
    }

    // MARK: -IBActions
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addCity()
    {
        self.cityName.resignFirstResponder()
        self.cityDescription.resignFirstResponder()
        
        let currentItem = Item(titleText: self.cityName.text!, iconPhoto: self.cityImage , descriptionText: self.cityDescription.text!)!
        
        self.itemsArray.append(currentItem)
        
        archiveItems(){ result in
            if result
            {
                self.indexNewCity(currentItem)
                self.navigationController?.popViewControllerAnimated(true)
            }
            else
            {
                print("Erro saving City! No index actions were performed")
            }
        }
    }
    
    // MARK: - TextField Delegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        self.saveButton.enabled = validateInformation()
        
        return true
    }


    // MARK: - TextView Delegate
    func textViewDidChange(textView: UITextView)  {
        self.saveButton.enabled = validateInformation()

    }
    
    // MARK: - Validation Method
    
    func validateInformation() -> Bool
    {
        var completeInformation = false
        
        if (self.cityName.text != ""  && self.cityDescription.text != "" && self.cityImage != nil)
        {
            completeInformation = true
        }
        
        return completeInformation
    }
    
    // MARK: NSCoding
    
    func archiveItems(completion:(result:Bool)->Void) {
        let isSaveCompleted = NSKeyedArchiver.archiveRootObject(itemsArray, toFile: Item.ArchiveURL.path!)
        if isSaveCompleted
        {
            NSLog("City Saved!")
            completion(result: true)
        }
        else
        {
            completion(result: false)
        }
    }
    
    //MARK: - NSUserActivity
    
    func indexNewCity(item: Item)
    {
        self.userActivity = UserActivityHelper.sharedInstance.indexItemForSearch(item)
        self.userActivity!.becomeCurrent()
    }
    
    override func updateUserActivityState(activity: NSUserActivity) {
        
        let imageData: NSData = UIImagePNGRepresentation(self.cityImage)!
        
        activity.addUserInfoEntriesFromDictionary([UserActivityConstants.kcityNameKey: self.cityName.text! as String, UserActivityConstants.kcityImageDataKey: imageData, UserActivityConstants.kcityDescriptionKey: self.cityDescription.text as String])
        super.updateUserActivityState(activity)
    }

}
