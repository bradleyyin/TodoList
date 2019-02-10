//
//  Category.swift
//  TodoList
//
//  Created by Bradley Yin on 2/10/19.
//  Copyright © 2019 Bradley Yin. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
