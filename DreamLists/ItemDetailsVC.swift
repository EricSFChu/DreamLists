//
//  ItemDetailsVC.swift
//  DreamLists
//
//  Created by EricDev on 5/22/17.
//  Copyright © 2017 EricDev. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var detailsField: UITextField!
    @IBOutlet weak var thumbImage: UIImageView!
    
    var stores = [Store]()
    var categories = [ItemType]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        //createStoreData()
        //createCategoryData()
        getStores()
        getCategories()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        storePicker.delegate = self
        storePicker.dataSource = self
        titleField.delegate = self
        priceField.delegate = self
        detailsField.delegate = self
        
        let tapGestureRec = UITapGestureRecognizer()
        tapGestureRec.addTarget(self, action: #selector(ItemDetailsVC.viewTapped))
        self.view.addGestureRecognizer(tapGestureRec)
        
        if itemToEdit != nil {
            loadItem()
        }
    }
    
    //number of columns in pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            
            return stores.count
            
        } else if component == 1 {
            
            return categories.count
            
        } else {
            
            return 0
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            
            let store = stores[row]
            
            return store.name
            
        } else if component == 1 {
            
            let category = categories[row]
            
            return category.type
            
        } else {
            
            return ""
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //update when selected
        
    }
    
    func viewTapped() {
        view.endEditing(true)
    }
    
    func getStores() {
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadComponent(0)
            
        } catch let error as NSError {
            
            NSLog(error.debugDescription)
            
        }
    }
    
    func getCategories() {
        
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do {
            
            self.categories = try context.fetch(fetchRequest)
            self.storePicker.reloadComponent(1)
            
        } catch let error as NSError {
            
            NSLog(error.debugDescription)
            
        }
    }
    
    @IBAction func saveItemPressed(_ sender: UIButton) {
        

        var item: Item!
        
        let picture = Image(context: context)
        picture.image = thumbImage.image
        
        //check if item already exists so that core data handles updating or inserting
        if itemToEdit == nil {
            
            item = Item(context: context)
            
        } else {
            
            //core data knows to update this item if it exists
            item = itemToEdit
            
        }
        
        item.toImage = picture
        
        if let title = titleField.text {
            
            item.title = title
            
        }

        if let price = priceField.text {
            
            item.price = (price as NSString).doubleValue
            
        }
        
        if let details = detailsField.text {
            
            item.details = details
            
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        item.toItemType = categories[storePicker.selectedRow(inComponent: 1)]
        
        ad.saveContext()
                
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func loadItem() {
        
        if let item = itemToEdit {
            
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumbImage.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                
                var index = 0
                repeat {
                    
                    let s = stores[index]
                    if s.name == store.name {
                        
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                        
                    }
                    
                    index += 1
                    
                } while (index < stores.count)
                
            }
            
            if let category = item.toItemType {
                
                var index = 0
                repeat {
                    
                    let c = categories[index]
                    if c.type == category.type {
                        
                        storePicker.selectRow(index, inComponent: 1, animated: false)
                        break
                        
                    }
                    
                    index += 1
                    
                } while (index < categories.count)
                
            }
        
        }
        
        
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        //Only delete if we passed an object over
        if itemToEdit != nil {
            
            context.delete(itemToEdit!)
            ad.saveContext()
            
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    

    @IBAction func imageButtonPressed(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            thumbImage.image = image
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func createCategoryData() {
        let cat = ItemType(context: context)
        cat.type = "Automobile"
        
        let cat2 = ItemType(context: context)
        cat2.type = "Electronic"
        
        let cat3 = ItemType(context: context)
        cat3.type = "Other"
        
        ad.saveContext()
    }
    
    func createStoreData() {
        let store = Store(context: context)
        store.name = "Best Buy"
        
        let store2 = Store(context: context)
        store2.name = "Diamler Benz Dealership"
        
        let store3 = Store(context: context)
        store3.name = "Ford Dealership"
        
        let store4 = Store(context: context)
        store4.name = "Tesla Dealership"
        
        let store5 = Store(context: context)
        store5.name = "GM Dealership"
        
        let store6 = Store(context: context)
        store6.name = "Honda Dealership"
        
        let store7 = Store(context: context)
        store7.name = "Acura Dealership"
        
        let store8 = Store(context: context)
        store8.name = "Amazon"
        
        ad.saveContext()
    }
}
