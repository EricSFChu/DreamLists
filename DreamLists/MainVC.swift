//
//  MainVC.swift
//  DreamLists
//
//  Created by EricDev on 5/21/17.
//  Copyright © 2017 EricDev. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    
    var fetchedResultsController: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //generateTestData()
        attemptFetch()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = fetchedResultsController.sections {
            
            return sections.count
            
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedResultsController.sections {
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
            
        }
        
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
    }
    
    // this can be used to adjust height for individual rows
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
        
        let item = fetchedResultsController.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
        
    }
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        let categorySort = NSSortDescriptor(key: "toItemType.type", ascending: true)
        
        if segmentedControll.selectedSegmentIndex == 0 {
            
            fetchRequest.sortDescriptors = [dateSort]
            
        } else if segmentedControll.selectedSegmentIndex == 1 {
            
            fetchRequest.sortDescriptors = [priceSort]
            
        } else if segmentedControll.selectedSegmentIndex == 2 {
            
            fetchRequest.sortDescriptors = [titleSort]
            
        } else if segmentedControll.selectedSegmentIndex == 3 {
            
            fetchRequest.sortDescriptors = [categorySort]
            
        }
        
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        fetchedResultsController = controller
        
        do {
            
            try controller.performFetch()
            
        } catch let error as NSError {
            
            print(error.debugDescription)
            
        }
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
            
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objs = fetchedResultsController.fetchedObjects, objs.count > 0 {
            
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
            
        }
        
    }
    
    func generateTestData() {
        
        let item = Item(context: context)
        
        item.title = "MacBook Pro"
        item.price = 1800.00
        item.details = "I can't believe I have to wait so long to get a new MBP, they better have a new one by then"
        
        let item2 = Item(context: context)
        
        item2.title = "Tesla X"
        item2.price = 120000.00
        item2.details = "This car looks amazing and has amazing range. Please let me have this!"
        
        let item3 = Item(context: context)
        
        item3.title = "BMW M3"
        item3.price = 89000.00
        item3.details = "This luxury car is a must have. I want it in blue."
        
        ad.saveContext()
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        attemptFetch()
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ItemDetailsVC" {
            
            if let destination = segue.destination as? ItemDetailsVC {
            
                if let item = sender as? Item {
                    
                    destination.itemToEdit = item
                    
                }
                
            }
        }
        
    }

}

