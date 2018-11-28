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
    @IBOutlet weak var walkingLabel: UILabel!
    @IBOutlet weak var stationaryLabel: UILabel!
    @IBOutlet weak var navigatingLabel: UILabel!
    @IBOutlet weak var altLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var accelLabel: UILabel!
    
    // Sensor object variables
    lazy var compassManager = CLLocationManager()
    lazy var altimeter = CMAltimeter()
    lazy var motionChecker = CMMotionActivityManager()
    lazy var deviceMotionManager = CMMotionManager()
    
    // Acceleration and velocity variables
    var accelXs : [Double] = [0, 0, 0, 0]
    var accelYs : [Double] = [0, 0, 0, 0]
    var accelZs : [Double] = [0, 0, 0, 0]
    var prevVx : Double = 0
    var prevVy : Double = 0
    var prevVz : Double = 0
    var accelCount : Int = 0
    var xAccelZeroCount : Int = 0
    var yAccelZeroCount : Int = 0
    var zAccelZeroCount : Int = 0
    var isWalk : Bool = false
    var isStay : Bool = false

    // Accelerometer filter constant and variables
//    let filterConstant = (1.0 / 60.0) * ((1.0 / 5.0) + (1.0 / 60.0))
    let filterConstant = 0.85
    var filteredAcc : CMAcceleration = CMAcceleration.init(x: 0, y: 0, z: 0)
    var prevAx : Double = 0
    var prevAy : Double = 0
    var prevAz : Double = 0

    // Scene variables
    var scene = SCNScene(named: "SceneFiles.scnassets/PathfinderScene.scn")!
    var sceneCamera = SCNScene(named: "SceneFiles.scnassets/PathfinderScene.scn")!.rootNode.childNode(withName: "sceneCamera", recursively: true)!
    
    // Test variables
    var maxAccX : Double = 0
    var maxAccY : Double = 0
    var maxAccZ : Double = 0
    var maxVelX : Double = 0
    var maxVelY : Double = 0
    var maxVelZ : Double = 0
    
    // Utility function
    func degToRad(_ degrees : Double) -> Float {
        return Float(degrees * .pi / 180)
    }
    
    // Magnetometer functions
    func startCompass() {
        if CLLocationManager.headingAvailable() {
            print("Compass is now active.")
            self.compassManager.headingFilter = 0.2
            self.compassManager.delegate = self
            self.compassManager.startUpdatingHeading()
        }
    }
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let userMarker = self.scene.rootNode.childNode(withName: "UserMarker", recursively: true)!
        userMarker.eulerAngles.z = -degToRad(90 + newHeading.magneticHeading)
    }
    func stopCompass() {
        if CLLocationManager.headingAvailable() {
            self.compassManager.stopUpdatingHeading()
        }
    }
    
    // Altimeter functions
    func startAltimeter() {
        if (CMAltimeter.isRelativeAltitudeAvailable()) {
            print("Altimeter is now active.")
            self.altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { (altitudeData:CMAltitudeData?, error:Error?) in
                
                if (error != nil) {
                    //                    self.stopAltimeter()
                } else {
                    let altitude = altitudeData!.relativeAltitude.floatValue
                    self.altLabel.text = String(format: "Rel. alt.: %.02f", altitude)
                }
                
            })
        }
    }
    func stopAltimeter() {
        if (CMAltimeter.isRelativeAltitudeAvailable()) {
            self.altLabel.text = "Rel. alt.: -----"
            self.altimeter.stopRelativeAltitudeUpdates()
        }
    }
    
    // Motion Activity Manager Functions
    func startMotionChecker () {
        if (CMMotionActivityManager.isActivityAvailable()) {
            print("Motion checker is now active.")
            self.motionChecker.startActivityUpdates(to: OperationQueue.main, withHandler: { (motionActivityData:CMMotionActivity?) in
                let isWalking = motionActivityData!.walking
                let isStationary = motionActivityData!.stationary
                let isNavigating = isWalking && !isStationary
                self.walkingLabel.text = "Wlk: \(isWalking)"
                self.stationaryLabel.text = "St: \(isStationary)"
                self.navigatingLabel.text = "Nav: \(isNavigating)"
                self.isWalk = isWalking
                self.isStay = isStationary
                
//                if (isNavigating == true || isStationary == false) {
//                    let user = self.scene.rootNode.childNode(withName: "UserMarker", recursively: true)!
//                    //user.position = SCNVector3(Double(xCurrent) + xAve, Double(zCurrent) + zAve, -1.687)
//                    user.simdPosition += user.simdWorldFront * 0.0004998
//                }
//                self.stopMotionChecker()

            }
            )
        }
    }
    func stopMotionChecker () {
        if (CMMotionActivityManager.isActivityAvailable()) {
            self.walkingLabel.text = "Wlk: -----"
            self.stationaryLabel.text = "St: -----"
            self.navigatingLabel.text = "Nav: -----"
            self.motionChecker.stopActivityUpdates()
            self.startMotionChecker()
        }
    }
    
    // Device Motion Manager functions
    func startDeviceMotionManager () {
        if (self.deviceMotionManager.isDeviceMotionAvailable) {
            print("Accelerometer and gyroscope are now active.")
            self.deviceMotionManager.accelerometerUpdateInterval = 1.0 / 60.0
            self.deviceMotionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { (deviceMotionData:CMDeviceMotion?, error:Error?)  in
                let accVec = deviceMotionData!.userAcceleration
                let rotMat = deviceMotionData!.attitude.rotationMatrix
                let correctedAccX = accVec.x * rotMat.m11 + accVec.x * rotMat.m12 + accVec.x * rotMat.m13
                let correctedAccY = accVec.y * rotMat.m21 + accVec.y * rotMat.m22 + accVec.x * rotMat.m23
                let correctedAccZ = accVec.z * rotMat.m31 + accVec.z * rotMat.m32 + accVec.z * rotMat.m33
                var correctedAcc = CMAcceleration.init(x: correctedAccX, y: correctedAccY, z: correctedAccZ)

//                // Filtering the raw accelerometer values
//                self.filteredAcc.x = self.filterConstant * (self.filteredAcc.x + correctedAcc.x - self.prevAx)
//                self.filteredAcc.y = self.filterConstant * (self.filteredAcc.y + correctedAcc.y - self.prevAy)
//                self.filteredAcc.z = self.filterConstant * (self.filteredAcc.z + correctedAcc.z - self.prevAz)
//                self.prevAx = correctedAcc.x
//                self.prevAy = correctedAcc.y
//                self.prevAz = correctedAcc.z
//
//                // Threshold
//                correctedAcc.x = (fabs(self.filteredAcc.x) < 0.03) ? 0 : self.filteredAcc.x
//                correctedAcc.y = (fabs(self.filteredAcc.y) < 0.03) ? 0 : self.filteredAcc.y
//                correctedAcc.z = (fabs(self.filteredAcc.z) < 0.03) ? 0 : self.filteredAcc.z
                
                correctedAcc.x = (fabs(correctedAcc.x) < 0.03) ? 0 : correctedAcc.x
                correctedAcc.y = (fabs(correctedAcc.y) < 0.03) ? 0 : correctedAcc.y
                correctedAcc.z = (fabs(correctedAcc.z) < 0.03) ? 0 : correctedAcc.z
                
                print("Filtered Acc X: \(correctedAcc.x)")
                print("Filtered Acc Y: \(correctedAcc.y)")
                print("Filtered Acc Z: \(correctedAcc.z)")

                // Index for acceleration values array
                self.accelCount = (self.accelCount + 1) % 4

                self.accelXs[self.accelCount] = correctedAcc.x
                self.accelYs[self.accelCount] = correctedAcc.y
                self.accelZs[self.accelCount] = correctedAcc.z

                if (self.accelCount == 3) {
                    self.prevVx += (4.0 / 8.0) * (1.0 / 60.0) * (self.accelXs[0] + 3 * self.accelXs[1] + 3 * self.accelXs[2] + self.accelXs[3])
                    self.prevVy += (4.0 / 8.0) * (1.0 / 60.0) * (self.accelYs[0] + 3 * self.accelYs[1] + 3 * self.accelYs[2] + self.accelYs[3])
                    self.prevVz += (4.0 / 8.0) * (1.0 / 60.0) * (self.accelZs[0] + 3 * self.accelZs[1] + 3 * self.accelZs[2] + self.accelZs[3])
                    
                    if (self.prevVx > self.maxVelX) {
                        self.maxVelX = self.prevVx
                        print("Max Speed X: \(self.maxVelX)")
                    }
                    if (self.prevVy > self.maxVelY) {
                        self.maxVelY = self.prevVy
                        print("Max Speed Y: \(self.maxVelY)")
                    }
                    if (self.prevVz > self.maxVelZ) {
                        self.maxVelZ = self.prevVz
                        print("Max Speed Z: \(self.maxVelZ)")
                    }
                }
                
                if (correctedAcc.x > self.maxAccX) {
                    self.maxAccX = correctedAcc.x
                    print("Max X Acc: \(self.maxAccX)")
                }
                if (correctedAcc.y > self.maxAccY) {
                    self.maxAccY = correctedAcc.y
                    print("Max Y Acc: \(self.maxAccY)")
                }
                if (correctedAcc.z > self.maxAccZ) {
                    self.maxAccZ = correctedAcc.z
                    print("Max Z Acc: \(self.maxAccZ)")
                }

                // "Synthetic forces" for removing velocity once relatively stationary
                if (correctedAcc.x == 0) {
                    self.xAccelZeroCount += 1
                }
                if (correctedAcc.y == 0) {
                    self.yAccelZeroCount += 1
                }
                if (correctedAcc.z == 0) {
                    self.zAccelZeroCount += 1
                }
                if (self.xAccelZeroCount == 20 || self.yAccelZeroCount == 20 || self.zAccelZeroCount == 20) {
                    self.prevVx = 0
                    self.prevVy = 0
                    self.prevVz = 0
                    self.xAccelZeroCount = 0
                    self.yAccelZeroCount = 0
                    self.zAccelZeroCount = 0
                }

//                if ((!self.isStay && self.prevVy > 0.012) || (self.isWalk && self.prevVy > 0.012) || (!self.isStay && self.prevVx > 0.012) || (self.isWalk && self.prevVx > 0.012)) {
                if ((self.prevVy > 0.012) || (self.prevVx > 0.012)) {
                    let user = self.scene.rootNode.childNode(withName: "UserMarker", recursively: true)!
                    user.simdPosition += user.simdWorldFront * 0.0004998
                    // try motion incorporating current speed
                }
                
                self.speedLabel.text = String(format: "v| x: %0.2f | y: %0.2f | z: %0.2f", self.prevVx, self.prevVy, self.prevVz)
                self.accelLabel.text = String(format: "a| x: %0.2f | y: %0.2f | z: %0.2f", correctedAcc.x, correctedAcc.y, correctedAcc.z)
                
            }
            )
        }
    }
    func stopDeviceMotionManager () {
        if (self.deviceMotionManager.isDeviceMotionAvailable) {
            self.speedLabel.text = "v| x: --- | y: --- | z: ---"
            self.accelLabel.text = "a| x: --- | y: --- | z: ---"
            self.deviceMotionManager.stopDeviceMotionUpdates()
        }
    }
    
    // Start and stop function for sensors
    func startSensors () {
        self.startCompass()
        self.startAltimeter()
        self.startMotionChecker()
        self.startDeviceMotionManager()
    }
    func stopSensors () {
        self.stopCompass()
        self.stopAltimeter()
        self.stopMotionChecker()
        self.stopDeviceMotionManager()
    }
    
    // MAIN
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
        
        // Activate the device's onboard sensors and start receiving updates
        self.startSensors()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        
        // Turn the sensors off and stop receiving updates
        self.stopSensors()
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
        print(error)
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
