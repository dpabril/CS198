//
//  ViewController.swift
//  AR Pathfinder
//
//  Created by Abril & Aquino on 03/10/2018.
//  Copyright © 2018 Abril & Aquino. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class IndoorNavigationViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var roomName : String = ""
    var userMarkerX : Int = 0
    var userMarkerY : Int = 0
    var pinMarkerX : Int = 0
    var pinMarkerY : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Pathing to " + roomName
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "SceneFiles.scnassets/PathfinderScene.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.pointOfView = scene.rootNode.childNode(withName: "sceneCamera", recursively: true)!
        
        let userMarker = scene.rootNode.childNode(withName: "UserMarker", recursively: true)!
        let pinMarker = scene.rootNode.childNode(withName: "LocationPinMarker", recursively: true)!
        
        
        //userMarker.position = SCNVector3((scannedImage.Y)/100, -0.073, (scannedImage.Y)/100)
        userMarker.position = SCNVector3(Double(userMarkerX) / Double(100), -0.073, Double(userMarkerY) / Double(100))
        pinMarker.position = SCNVector3(0.376, -0.08, -0.21)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
