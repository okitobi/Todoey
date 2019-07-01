//
//  Item.swift
//  Todoey
//
//  Created by Joseph Ray on 7/1/19.
//  Copyright © 2019 Joseph Ray. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object
{
    @objc dynamic var itemName : String = ""
    @objc dynamic var itemCompleted : Bool = false
    @objc dynamic var dateCreated : Date?
    
    // to do the "type", it is just the name of the relational class .self, and property is the linking List var
    // that is used in the relationed class, but written as a string
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    
}
