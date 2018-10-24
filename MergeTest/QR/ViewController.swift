import UIKit
import SpriteKit
import ARKit

struct ImageInformation {
    /*
     let name: String
     let description: String
     let image: UIImage
     */
    
    let building: String
    let room: String
    let x: Int
    let y: Int
    let destination: String
    let image: UIImage
}

class ViewController: UIViewController, ARSKViewDelegate {
    @IBOutlet var sceneView: ARSKView!
    var selectedImage : ImageInformation?
    var userMarkerXforLocList : Int = 0
    var userMarkerYforLocList : Int = 0
    
    let images = ["monalisa" : ImageInformation(building: "Building: UP AECH", room: "Room: WSG Lab", x: 8, y: 10, destination: "Destination: CLR1, CLR2, CLR3", image: UIImage(named: "monalisa")!), "cssp" : ImageInformation(building: "Building: Palma Hall", room: "Room: PH 400", x: 88, y: 108, destination: "Destination: PAV1, PAV2", image: UIImage(named: "cssp")!)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
//        sceneView.showsFPS = true
//        sceneView.showsNodeCount = true
        
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "Mona Lisa Room", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        

    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        self.viewDidLoad()
    }
    
    // MARK: - ARSKViewDelegate
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        
        if let imageAnchor = anchor as? ARImageAnchor,
            let referenceImageName = imageAnchor.referenceImage.name,
            let scannedImage =  self.images[referenceImageName] {
            
            self.selectedImage = scannedImage
            self.userMarkerXforLocList = scannedImage.x
            self.userMarkerYforLocList = scannedImage.y
           
            
//            self.setUserMarker(xVal: scannedImage.x, yVal: scannedImage.y, segDest: <#T##UIStoryboardSegue#>)
            self.performSegue(withIdentifier: "goToLocList", sender: self)
            
            //            return imageSeenMarker()
            
            
            
        }
        
        
        
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToLocList" {   // get a reference to the second view controller
            let locListController = segue.destination as! LocationTableViewController

            // set a variable in the second view controller with the data to pass
            locListController.userMarkerX = userMarkerXforLocList
            locListController.userMarkerY = userMarkerYforLocList
        }

    }
    
    func setUserMarker(xVal : Int, yVal : Int, segDest : UIStoryboardSegue) {
        let pathfinderController = segDest.destination as! IndoorNavigationViewController
        pathfinderController.userMarkerX = xVal
        pathfinderController.userMarkerY = yVal
    }
}
