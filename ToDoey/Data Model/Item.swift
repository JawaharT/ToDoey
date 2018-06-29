//
//  Item.swift
//  ToDoey
//
//  Created by Jawahar Tunuguntla on 29/06/2018.
//  Copyright © 2018 Jawahar Tunuguntla. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCatagory = LinkingObjects(fromType: Catagory.self, property: "items")
}
