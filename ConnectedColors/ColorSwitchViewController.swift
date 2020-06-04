import UIKit

class ColorSwitchViewController: UIViewController {

    @IBOutlet weak var connectionsLabel: UILabel!

    // Assuming iPad server and iPhone client
    let colorRoot = UIDevice.current.model == "iPad" ? ColorServer() : ColorClient()

    override func viewDidLoad() {
        super.viewDidLoad()
        colorRoot.delegate = self
    }

    @IBAction func redTapped() {
        self.change(color: .red)
        colorRoot.send(colorName: "red")
    }

    @IBAction func yellowTapped() {
        self.change(color: .yellow)
        colorRoot.send(colorName: "yellow")
    }

    func change(color : UIColor) {
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = color
        }
    }
    
}

extension ColorSwitchViewController : ColorRootDelegate {

    func connectedDevicesChanged(manager: ColorRoot, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.connectionsLabel.text = "Connections: \(connectedDevices)"
        }
    }

    func colorChanged(manager: ColorRoot, colorString: String) {
        OperationQueue.main.addOperation {
            switch colorString {
            case "red":
                self.change(color: .red)
            case "yellow":
                self.change(color: .yellow)
            default:
                NSLog("%@", "Unknown color value received: \(colorString)")
            }
        }
    }

}
