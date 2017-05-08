//
//  BlindsViewController.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-03.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import UIKit
import SWRevealViewController

class BlindsViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    enum Blind: Int{
        case bedroom, livingroom, patio
        
        var stringInterpretation: String {
            switch self{
            case .bedroom:
                return "Bedroom"
            case .livingroom:
                return "Livingroom"
            case .patio:
                return "Patio"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "greyGradient.jpg")!)
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func toggleBlind(_ sender: UIButton) {
        sender.zoomIn(scale: 1.3, duration: 0.1, delay: 0.0, options: [])
        toggleButton(sender: sender)
        if let blind = Blind(rawValue: sender.tag) {
            //No authentication for Blinds
            BlindsService(authenticate: false).toggle(blindName: blind.stringInterpretation, toggle: BlindsToggle.close, auth: false) { (result) in
                guard result.isSuccess else{
                    //Not sure what to do with the error message
                    print(result.error.debugDescription)
                    //commented out for testing purposes
                    //self.alertUser(title: NSLocalizedString("Error", comment: "Error title"), message: NSLocalizedString("An error has occurred", comment: "The error message"))
                    return
                }
                self.toggleButton(sender: sender)
            }
        }
    }
    
    private func toggleButton(sender: UIButton){
        if let state = sender.titleLabel?.text{
            switch state {
            case "on":
                sender.setTitle("off", for: .normal)
                sender.setImage(UIImage(named: "blindClose"), for: .normal)
                break
            case "off":
                sender.setTitle("on", for: .normal)
                sender.setImage(UIImage(named: "blindOpen"), for: .normal)
                break
            default:
                break
            }
        }else {
            self.alertUser(title: "Error".localized, message: "An error has occurred".localized)
        }
    }

}
