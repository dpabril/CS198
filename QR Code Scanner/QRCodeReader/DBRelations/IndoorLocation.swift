//
//  IndoorLocation.swift
//  QRCodeReader
//
//  Created by Abril & Aquino on 07/12/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import GRDB

class IndoorLocation : Record {
    var bldg : String
    var level : Int
    var name : String
    var xcoord : Double
    var ycoord : Double
    
    init(bldg: String, level: Int, name: String, xcoord: Double, ycoord: Double) {
        self.bldg = bldg
        self.level = level
        self.name = name
        self.xcoord = xcoord
        self.ycoord = ycoord
        super.init()
    }
    
    override class var databaseTableName : String {
        return "IndoorLocation"
    }
    
    enum Columns : String, ColumnExpression {
        case bldg, level, name, xcoord, ycoord
    }
    
    required init(row: Row) {
        bldg = row[Columns.bldg]
        level = row[Columns.level]
        name = row[Columns.name]
        xcoord = row[Columns.xcoord]
        ycoord = row[Columns.ycoord]
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.bldg] = bldg
        container[Columns.level] = level
        container[Columns.name] = name
        container[Columns.xcoord] = xcoord
        container[Columns.ycoord] = ycoord
    }
}
