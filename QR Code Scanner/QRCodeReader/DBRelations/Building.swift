//
//  Building.swift
//  QRCodeReader
//
//  Created by Abril & Aquino on 07/12/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import GRDB

class Building : Record {
    var alias : String
    var name : String
    var floors : Int
    var delta : Double
    
    init(alias: String, name: String, floors: Int, delta: Double) {
        self.alias = alias
        self.name = name
        self.floors = floors
        self.delta = delta
        super.init()
    }
    
    override class var databaseTableName : String {
        return "Building"
    }
    
    enum Columns : String, ColumnExpression {
        case alias, name, floors, delta
    }
    
    required init(row: Row) {
        alias = row[Columns.alias]
        name = row[Columns.name]
        floors = row[Columns.floors]
        delta = row[Columns.delta]
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.alias] = alias
        container[Columns.name] = name
        container[Columns.floors] = floors
        container[Columns.delta] = delta
    }
}
