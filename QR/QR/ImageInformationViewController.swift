import UIKit

class ImageInformationViewController : UIViewController {
    /*
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    */
    @IBOutlet weak var buildingLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var destinationText: UITextView!
    
    
    var imageInformation : ImageInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let actualImageInformation = imageInformation {
            /*
            self.nameLabel.text = actualImageInformation.name
            self.imageView.image = actualImageInformation.image
            self.descriptionText.text = actualImageInformation.description
            */
            
            self.buildingLabel.text = actualImageInformation.building
            self.roomLabel.text = actualImageInformation.room
            self.xLabel.text = actualImageInformation.x
            self.yLabel.text = actualImageInformation.y
            self.destinationText.text = actualImageInformation.destination
            
            
            //print("hello")
        }
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
