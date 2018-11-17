//
//  ViewController.swift
//  NavScene
//
//  Created by Abril & Aquino on 12/11/2018.
//  Copyright © 2018 Abril & Aquino. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation
import CoreMotion

class ViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var altLabel: UILabel!
    @IBOutlet weak var walkingLabel: UILabel!
    @IBOutlet weak var stationaryLabel: UILabel!
    
    lazy var compassManager = CLLocationManager()
    lazy var altimeter = CMAltimeter()
    lazy var motionChecker = CMMotionActivityManager()

    var scene = SCNScene(named: "SceneFiles.scnassets/PathfinderScene.scn")!
    var sceneCamera = SCNScene(named: "SceneFiles.scnassets/PathfinderScene.scn")!.rootNode.childNode(withName: "sceneCamera", recursively: true)!

    // Utility function
    func degToRad(_ degrees : Double) -> Float {
        return Float(degrees * .pi / 180)
    }
    
    // Magnetometer functions
    func startCompass() {
        if CLLocationManager.headingAvailable() {
            self.compassManager.headingFilter = 0.2
            self.compassManager.delegate = self
            self.compassManager.startUpdatingHeading()
        }
    }
    func stopCompass() {
        if CLLocationManager.headingAvailable() {
            self.compassManager.stopUpdatingHeading()
        }
    }
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let map = self.scene.rootNode.childNode(withName: "map", recursively: true)!
//        let userMarker = self.scene.rootNode.childNode(withName: "UserMarker", recursively: true)!
        map.rotation = SCNVector4(0, 0, 1, degToRad(90 + newHeading.magneticHeading))
    }
    
    // Altimeter functions
    func startAltimeter() {
        if (CMAltimeter.isRelativeAltitudeAvailable()) {
            self.altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { (altitudeData:CMAltitudeData?, error:Error?) in
    
                if (error != nil) {
//                    self.stopAltimeter()
                } else {
                    let altitude = altitudeData!.relativeAltitude.floatValue
                    self.altLabel.text = String(format: "Relative altitude: %.02f", altitude)
                }
                
            })
        }
    }
    func stopAltimeter() {
        self.altLabel.text = "Relative altitude: ----"
        self.altimeter.stopRelativeAltitudeUpdates()
    }
    
    // Motion Activity Manager Functions
    func startMotionChecker () {
        if (CMMotionActivityManager.isActivityAvailable()) {
            self.motionChecker.startActivityUpdates(to: OperationQueue.main, withHandler: { (motionActivityData:CMMotionActivity?) in
                
                    let isWalking = motionActivityData!.walking
                    let isStationary = motionActivityData!.stationary
                    self.walkingLabel.text = String("Walking: \(isWalking)")
                    self.stationaryLabel.text = String("Stationary: \(isStationary)")
                }
            )
        }
    }
//    func stopMotionChecker () {
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Set the scene to the view
        sceneView.scene = self.scene
        sceneView.pointOfView = self.sceneCamera
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
        
        // Start gettting compass updates
        self.startCompass()
        self.startAltimeter()
        self.startMotionChecker()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        
        // Stop the compass
        self.stopCompass()
        self.stopAltimeter()
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
