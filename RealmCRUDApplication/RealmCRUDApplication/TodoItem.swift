//
//  TodoItem.swift
//  RealmCRUDApplication
//
//  Created by Johan Lindström on 2020-12-14.
//

import RealmSwift
// Realm Object Model
class TodoItem: Object {
    @objc dynamic var detail = ""
    @objc dynamic var status = 0
}
