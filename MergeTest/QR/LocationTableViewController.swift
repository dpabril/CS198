//
//  LocationTableViewController.swift
//  AR Pathfinder
//
//  Created by Abril & Aquino on 16/10/2018.
//  Copyright © 2018 Abril & Aquino. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController {
    
    let dcsRooms = ["CLR 1", "CLR 2", "CLR 3", "CLR 4", "AIER", "ERDT", "TL1", "TL2", "TL3"]
    var selectedRoom : String = ""
    var userMarkerX : Int = 0
    var userMarkerY : Int = 0
    var pinMarkerX : Int = 0
    var pinMarkerY : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "UP AECH"
//        self.navigationItem.backBarButtonItem?.title = "Back"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
//        return roomtypes.count
        return 1
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection roomtype: Int) -> String? {
//        return "Choose a Room"
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection roomtype: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dcsRooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListRow", for: indexPath)
        
//        switch indexPath.section {
//        case 0:
//            cell.textLabel?.text = rooms[indexPath.row]
//            break
//        case 1:
//            cell.textLabel?.text = labs[indexPath.row]
//            break
//        default:
//            break
//        }
        cell.textLabel?.text = dcsRooms[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Segue to the second view controller
        let selectedCell = tableView.cellForRow(at: indexPath) as! UITableViewCell
        self.selectedRoom = selectedCell.textLabel!.text!
        self.performSegue(withIdentifier: "showPathfinder", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPathfinder" {   // get a reference to the second view controller
            let pathfinderController = segue.destination as! IndoorNavigationViewController
            
            // set a variable in the second view controller with the data to pass
            pathfinderController.roomName = self.selectedRoom
            pathfinderController.userMarkerX = userMarkerX
            pathfinderController.userMarkerY = userMarkerY
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
