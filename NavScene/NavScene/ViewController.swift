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
    
    lazy var compassManager = CLLocationManager()
    lazy var altimeter = CMAltimeter()
    lazy var motionChecker = CMMotionActivityManager()
    lazy var deviceMotionManager = CMMotionManager()
    
    var xVals: [Double] = []
    var xCurrent: Double = 0
    var zVals: [Double] = []
    var zCurrent: Double = 0
    
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
    
    var scene = SCNScene(named: "SceneFiles.scnassets/PathfinderScene.scn")!
    var sceneCamera = SCNScene(named: "SceneFiles.scnassets/PathfinderScene.scn")!.rootNode.childNode(withName: "sceneCamera", recursively: true)!
    
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
    func stopCompass() {
        if CLLocationManager.headingAvailable() {
            self.compassManager.stopUpdatingHeading()
        }
    }
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let userMarker = self.scene.rootNode.childNode(withName: "UserMarker", recursively: true)!
        userMarker.eulerAngles.z = -degToRad(90 + newHeading.magneticHeading)
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
        }
    }
    
    // Device Motion Manager functions
    func startDeviceMotionManager () {
        if (self.deviceMotionManager.isDeviceMotionAvailable) {
            print("Accelerometer and gyroscope are now active.")
            self.deviceMotionManager.accelerometerUpdateInterval = 1.0 / 30.0
            self.deviceMotionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { (deviceMotionData:CMDeviceMotion?, error:Error?)  in
                let accVec = deviceMotionData!.userAcceleration
                let rotMat = deviceMotionData!.attitude.rotationMatrix
                let correctedAccX = accVec.x * rotMat.m11 + accVec.x * rotMat.m12 + accVec.x * rotMat.m13
                let correctedAccY = accVec.y * rotMat.m21 + accVec.y * rotMat.m22 + accVec.x * rotMat.m23
                let correctedAccZ = accVec.z * rotMat.m31 + accVec.z * rotMat.m32 + accVec.z * rotMat.m33
                var correctedAcc = CMAcceleration.init(x: correctedAccX, y: correctedAccY, z: correctedAccZ)

                /*
                 Code for filtering accelerometer readings here
                 */

                // Threshold (* SUBSTITUTE correctedAcc WITH FILTERED VALUES)
                correctedAcc.x = (fabs(correctedAcc.x) > 0.05) ? correctedAcc.x : 0
                correctedAcc.y = (fabs(correctedAcc.y) > 0.05) ? correctedAcc.y : 0
                correctedAcc.z = (fabs(correctedAcc.z) > 0.05) ? correctedAcc.z : 0

                // Index for acceleration values array
                self.accelCount = (self.accelCount + 1) % 4

                self.accelXs[self.accelCount] = correctedAcc.x
                self.accelYs[self.accelCount] = correctedAcc.y
                self.accelZs[self.accelCount] = correctedAcc.z

                if (self.accelCount == 3) {
                    self.prevVx += (3.0 / 8.0) * (4.0 / 60.0) * (self.accelXs[0] + 3 * self.accelXs[1] + 3 * self.accelXs[2] + self.accelXs[3])
                    self.prevVy += (3.0 / 8.0) * (4.0 / 60.0) * (self.accelYs[0] + 3 * self.accelYs[1] + 3 * self.accelYs[2] + self.accelYs[3])
                    self.prevVz += (3.0 / 8.0) * (4.0 / 60.0) * (self.accelZs[0] + 3 * self.accelZs[1] + 3 * self.accelZs[2] + self.accelZs[3])
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
                if (self.xAccelZeroCount == 15) {
                    self.prevVx = 0
                    self.xAccelZeroCount = 0
                }
                if (self.yAccelZeroCount == 15) {
                    self.prevVy = 0
                    self.yAccelZeroCount = 0
                }
                if (self.zAccelZeroCount == 15) {
                    self.prevVz = 0
                    self.zAccelZeroCount = 0
                }
                //
                //                self.xSpeedLabel.text = String(format: "vx: %0.2f", self.prevVx)
                //                self.zSpeedLabel.text = String(format: "vz: %0.2f", self.prevVz)
                self.speedLabel.text = String(format: "v| x: %0.2f | y: %0.2f | z: %0.2f", self.prevVx, self.prevVy, self.prevVz)
                self.accelLabel.text = String(format: "a| x: %0.2f | y: %0.2f | z: %0.2f", correctedAcc.x, correctedAcc.y, correctedAcc.z)
                
                
                self.xVals += [accVec.x]
                // self.xAccelerationLabel.text = String(format: "x: %0.2f", accVec.x)
                
                self.zVals.append(accVec.z)
                // self.zAccelerationLabel.text = String(format: "z: %0.2f", accVec.z)
                
                
                // Logging acceleration vector values
            }
            )
        }
    }
    func stopDeviceMotionManager () {
        if (self.deviceMotionManager.isDeviceMotionAvailable) {
//            self.xAccelerationLabel.text = "x: ---"
//            self.zAccelerationLabel.text = "z: ---"
//            self.xSpeedLabel.text = "vx: ---"
//            self.zSpeedLabel.text = "vz: ---"
            self.deviceMotionManager.stopDeviceMotionUpdates()
        }
    }
    
    // Start and stop function for sensors
    func startSensors () {
        self.startCompass()
        self.startAltimeter()
        self.startMotionChecker()
        self.startDeviceMotionManager()
        
        /*
         DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
         self.stopSensors()
         }
         */
        
    }
    func stopSensors () {
        self.stopCompass()
        self.stopAltimeter()
        self.stopMotionChecker()
        self.stopDeviceMotionManager()
        
        /*
         print("X VALUES")
         print(xVals)
         print("xVals size")
         print(xVals.count)
         print("zVals size")
         print(zVals.count)
         print("xVals Total")
         print(xVals.reduce(0, +))
         */
        
        print("xCurrent")
        print(xCurrent)
        print("xVals Ave")
        let xAve = (xVals.reduce(0, +)/Double(xVals.count))*0.1
        print(xAve)
        
        //print("zVals Ave")
        let zAve = (zVals.reduce(0, +)/Double(zVals.count))*0.1
        //print(zAve)
        
        let user = self.scene.rootNode.childNode(withName: "UserMarker", recursively: true)!
        user.position = SCNVector3(Double(xCurrent) + xAve, Double(zCurrent) + zAve, -1.687)
        
        xCurrent = xCurrent + xAve
        zCurrent = zCurrent + zAve
        
        xVals.removeAll()
        zVals.removeAll()
        self.startSensors()
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
        
        self.startSensors()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        
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
