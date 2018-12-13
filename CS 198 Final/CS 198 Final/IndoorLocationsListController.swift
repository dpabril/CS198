//
//  IndoorLocationsListController.swift
//  CS 198 Final
//
//  Created by Abril & Aquino on 11/12/2018.
//  Copyright © 2018 Abril & Aquino. All rights reserved.
//

import UIKit

class IndoorLocationsListController: UITableViewController {
    
    var roomList : [String] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.roomList = (self.tabBarController!.viewControllers![0] as! QRCodeScannerController).rooms
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection roomtype: Int) -> Int {
        return roomList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListRow", for: indexPath)
        cell.textLabel?.text = roomList[indexPath.row]
        return cell
    }
}
