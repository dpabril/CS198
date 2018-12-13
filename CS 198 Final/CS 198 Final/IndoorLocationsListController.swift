//
//  IndoorLocationsListController.swift
//  CS 198 Final
//
//  Created by Abril & Aquino on 11/12/2018.
//  Copyright © 2018 Abril & Aquino. All rights reserved.
//

import UIKit

class IndoorLocationsListController: UITableViewController {

    var locs : [IndoorLocation] = []
    var rooms : [String] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let building = (self.tabBarController!.viewControllers![0] as! QRCodeScannerController).qrCodeBuilding
        
        let floor = (self.tabBarController!.viewControllers![0] as! QRCodeScannerController).qrCodeFloorLevel
        
        do {
            try DB.write { db in
                locs = try IndoorLocation.fetchAll(db, "SELECT * FROM IndoorLocation WHERE bldg = ? AND level = ?", arguments: [building, floor])
            }
        } catch {
            print(error)
        }
    
        //print(locs[0].name)
        //print("DONE")
        
        rooms = []
        
        for loc in locs {
            rooms.append(loc.name)
        }
        print(rooms.count)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomList", for: indexPath)
        print(rooms)
        cell.textLabel?.text = rooms[indexPath.row]
        return cell
    }
    
}
