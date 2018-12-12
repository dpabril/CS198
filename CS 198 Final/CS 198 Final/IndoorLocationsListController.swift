//
//  IndoorLocationsListController.swift
//  CS 198 Final
//
//  Created by Abril & Aquino on 11/12/2018.
//  Copyright © 2018 Abril & Aquino. All rights reserved.
//

import UIKit

class IndoorLocationsListController: UITableViewController {
    
//    var building : String = ""
//    var floor : Int = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let building = (self.tabBarController!.viewControllers![0] as! QRCodeScannerController).qrCodeBuilding
        
        let floor = (self.tabBarController!.viewControllers![0] as! QRCodeScannerController).qrCodeFloorLevel
        
        var locs : [IndoorLocation] = []
        
        do {
            try DB.write { db in
                locs = try IndoorLocation.fetchAll(db, "SELECT * FROM IndoorLocation WHERE bldg = ? AND level = ?", arguments: [building, floor])
            }
        } catch {
            print(error)
        }
    
        print(locs[0].name)
        print("DONE")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        self.building = ""
//        self.floor = 0
        print("DISAPPEARING")
    }
    
}
