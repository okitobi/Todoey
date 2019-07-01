//
//  Category.swift
//  Todoey
//
//  Created by Joseph Ray on 7/1/19.
//  Copyright © 2019 Joseph Ray. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object
{
    @objc dynamic var categoryName : String = ""
    
    let items = List<Item>()
}
