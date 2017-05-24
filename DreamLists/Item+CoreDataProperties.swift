//
//  Item+CoreDataProperties.swift
//  DreamLists
//
//  Created by EricDev on 5/21/17.
//  Copyright © 2017 EricDev. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var details: String?
    @NSManaged public var created: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var price: Double
    @NSManaged public var toImage: Image?
    @NSManaged public var toItemType: ItemType?
    @NSManaged public var toStore: Store?

}
