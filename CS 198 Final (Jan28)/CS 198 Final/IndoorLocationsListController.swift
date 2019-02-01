//
//  IndoorLocationsListController.swift
//  CS 198 Final
//
//  Created by Abril & Aquino on 11/12/2018.
//  Copyright © 2018 Abril & Aquino. All rights reserved.
//

import UIKit
import GRDB

class IndoorLocationsListController: UITableViewController {
    
    var roomList : [IndoorLocation] = []
    // <NEW>
    var roomListIndex : Int = 0
    var currentBuilding : Building!
    // </NEW>
    
    var xCoord : Double = 0
    var yCoord : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currentBuilding = (self.tabBarController!.viewControllers![0] as! QRCodeScannerController).currentBuilding
        self.roomList = (self.tabBarController!.viewControllers![0] as! QRCodeScannerController).locs
        self.tableView.reloadData()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // return 1
        // <NEW>
        return (self.tabBarController!.viewControllers![0] as! QRCodeScannerController).currentBuilding.floors
        // </NEW>
    }
    
    // <NEW>
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (self.currentBuilding.hasLGF == true) {
            switch section {
            case 0:
                return "Lower Ground Floor"
            case 1:
                return "Upper Ground Floor"
            case 2:
                return "Second Floor"
            case 3:
                return "Third Floor"
            case 4:
                return "Fourth Floor"
            case 5:
                return "Fifth Floor"
            default:
                return "Secret Floor"
            }
        } else {
            switch section {
            case 0:
                return "Ground Floor"
            case 1:
                return "Second Floor"
            case 2:
                return "Thirds Floor"
            case 3:
                return "Fourth Floor"
            case 4:
                return "Fifth Floor"
            case 5:
                return "Sixth Floor"
            default:
                return "Secret Floor"
            }
        }
    }
    // </NEW>
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection floor: Int) -> Int {
        // return roomList.count
        // <NEW>
        var locsCountInFloor : Int = 0
        do {
            try DB.write { db in
                if (self.currentBuilding!.hasLGF == true) {
                    locsCountInFloor = try IndoorLocation.filter(Column("bldg") == self.currentBuilding.alias && Column("level") == floor).fetchCount(db)
                } else {
                    locsCountInFloor = try IndoorLocation.filter(Column("bldg") == self.currentBuilding.alias && Column("level") == floor + 1).fetchCount(db)
                }
            }
        } catch {
            print(error)
        }
        return locsCountInFloor
        // </NEW>
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListRow", for: indexPath)
        cell.textLabel?.text = roomList[indexPath.row].title
        // <NEW>
        // set cell type to 'subtitle' in Interface Builder
        cell.detailTextLabel?.text = roomList[indexPath.row].subtitle
//        self.roomListIndex += 1
        print(indexPath.row)
        // </NEW>
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.xCoord = roomList[indexPath.row].xcoord
        self.yCoord = roomList[indexPath.row].ycoord
        // <NEW>
        // self.tabBarController!.switchTab(tabBarController: self.tabBarController!, to: self.tabBarController!.viewControllers![1])
        // </NEW>
        self.tabBarController!.selectedIndex = 1
    }

}
