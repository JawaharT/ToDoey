//
//  Catagory.swift
//  ToDoey
//
//  Created by Jawahar Tunuguntla on 29/06/2018.
//  Copyright © 2018 Jawahar Tunuguntla. All rights reserved.
//

import Foundation
import RealmSwift

class Catagory: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
