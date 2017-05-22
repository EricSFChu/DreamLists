//
//  ItemType+CoreDataProperties.swift
//  DreamLists
//
//  Created by EricDev on 5/21/17.
//  Copyright © 2017 EricDev. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
