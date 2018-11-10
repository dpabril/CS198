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
import CoreLocation

class IndoorNavigationViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    lazy var compassManager = CLLocationManager()
    
    func startCompass() {
        if CLLocationManager.headingAvailable() {
            self.compassManager.headingFilter = 5
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
        print("\(newHeading.magneticHeading)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "SceneFiles.scnassets/PathfinderScene.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.pointOfView = scene.rootNode.childNode(withName: "sceneCamera", recursively: true)!
        
        self.startCompass()
        
        let user = scene.rootNode.childNode(withName: "UserMarker", recursively: true)!
//        let pin = scene.rootNode.childNode(withName: "LocationPinMarker", recursively: true)!
//        let arrow = scene.rootNode.childNode(withName: "ArrowMarker", recursively: true)!
//        user.position = SCNVector3(0, 0, 0)
        
//        var pinAnimations = [CABasicAnimation]()
//
//        let pinBobAnimation = CABasicAnimation(keyPath: "translation.y")
//        pinBobAnimation.fromValue = pin.position.y
//        pinBobAnimation.toValue = -0.030
//        pinBobAnimation.duration = 1.0
//        pinBobAnimation.autoreverses = true
////        pinBobAnimation.repeatCount = .infinity
//        pinAnimations.append(pinBobAnimation)
////        pin.addAnimation(pinBobAnimation, forKey: nil)
//
//        let pinRotateAnimation = CABasicAnimation(keyPath: "eulerAngles.y")
//        pinRotateAnimation.fromValue = pin.eulerAngles.y
//        pinRotateAnimation.toValue = pin.eulerAngles.y + (2 * .pi)
//        pinRotateAnimation.duration = 2.0
////        pinRotateAnimation.repeatCount = .infinity
//        pinAnimations.append(pinRotateAnimation)
////        pin.addAnimation(pinRotateAnimation, forKey: nil)
//
//        let pinAnimationsGroup = CAAnimationGroup()
//        pinAnimationsGroup.duration = 2.0
//        pinAnimationsGroup.animations = pinAnimations
//        pinAnimationsGroup.repeatCount = .infinity
//
//        pin.addAnimation(pinAnimationsGroup, forKey: nil)
//
//        let arrowScaleAnimation1 = CABasicAnimation(keyPath: "scale.x")
//        arrowScaleAnimation1.fromValue = arrow.scale.x
//        arrowScaleAnimation1.toValue = arrow.scale.x - 0.025
//        arrowScaleAnimation1.duration = 0.75
//        arrowScaleAnimation1.autoreverses = true
//        arrowScaleAnimation1.repeatCount = .infinity
//        arrow.addAnimation(arrowScaleAnimation1, forKey: nil)
//
//        let arrowScaleAnimation2 = CABasicAnimation(keyPath: "scale.z")
//        arrowScaleAnimation2.fromValue = arrow.scale.z
//        arrowScaleAnimation2.toValue = arrow.scale.z - 0.025
//        arrowScaleAnimation2.duration = 0.75
//        arrowScaleAnimation2.autoreverses = true
//        arrowScaleAnimation2.repeatCount = .infinity
//        arrow.addAnimation(arrowScaleAnimation2, forKey: nil)
        
        
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
        self.stopCompass()
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
