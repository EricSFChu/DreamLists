//
//  Item+CoreDataClass.swift
//  DreamLists
//
//  Created by EricDev on 5/21/17.
//  Copyright © 2017 EricDev. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.created = NSDate()
    }

}
