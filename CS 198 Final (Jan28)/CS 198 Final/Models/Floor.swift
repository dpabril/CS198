//
//  Floor.swift
//  CS 198 Final
//
//  Created by Abril & Aquino on 11/12/2018.
//  Copyright © 2018 Abril & Aquino. All rights reserved.
//

import GRDB

class Floor : Record {
    var bldg : String
    var level : Int
    var plan : String
    
    init(bldg: String, level: Int, plan: String) {
        self.bldg = bldg
        self.level = level
        self.plan = plan
        super.init()
    }
    
    override class var databaseTableName : String {
        return "Floor"
    }
    
    enum Columns : String, ColumnExpression {
        case bldg, level, plan
    }
    
    required init(row: Row) {
        bldg = row[Columns.bldg]
        level = row[Columns.level]
        plan = row[Columns.plan]
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.bldg] = bldg
        container[Columns.level] = level
        container[Columns.plan] = plan
    }
}
