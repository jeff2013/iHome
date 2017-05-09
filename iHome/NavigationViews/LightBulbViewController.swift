//
//  HomeViewController.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-02.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import UIKit
import SWRevealViewController

class LightBulbViewController: UIViewController {
    
    enum Light: Int {
        case mainLamp
        case deskLamp
        case moodLight
    
        var stringInterpretation: String {
            switch self{
            case .mainLamp:
                return "mainLamp"
            case .deskLamp:
                return "deskLamp"
            case .moodLight:
                return "moodLight"
            }
        }
    }
    
    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var mainLampLabel: UILabel!
    @IBOutlet weak var deskLampLabel: UILabel!
    @IBOutlet weak var moodLightLabel: UILabel!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var mainLampButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "greyGradient.jpg")!)
        pageTitleLabel.font = TextStyleModel.FontStyle.pageTitle.getFont()
        setButtonLabels(labels: [mainLampLabel, deskLampLabel, moodLightLabel])
        
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
    }
    
    func setButtonLabels(labels: [UILabel]) {
        for label in labels {
            label.font = TextStyleModel.FontStyle.buttonLabels.getFont()
        }
    }
    
    //toggles light on and off using the title of the button as a stateholder
    @IBAction func toggleLight(_ sender: UIButton) {
        sender.zoomIn(scale: 1.3, duration: 0.1, delay: 0.0, options: [])
        toggleButton(sender: sender)
        NotificationService().createNotification(notification: NotificationModel.LightsNotification)
        if let light = Light(rawValue: sender.tag) {
            LightsService.toggle(lightName: light.stringInterpretation, toggle: LightToggle.off, auth: false) { (result) in
                guard result.isSuccess else{
                    //Not sure what to do with the error message
                    print(result.error.debugDescription)
                    //self.alertUser(title: NSLocalizedString("Error", comment: "Error title"), message: NSLocalizedString("An error has occurred", comment: "The error message"))
                    return
                }
                self.toggleButton(sender: sender)
            }
        }
    }
    
    private func toggleButton(sender: UIButton) {
        if let state = sender.titleLabel?.text {
            switch state {
            case "on":
                sender.setTitle("off", for: .normal)
                sender.setImage(UIImage(named: "switchOff"), for: .normal)
                break
            case "off":
                sender.setTitle("on", for: .normal)
                sender.setImage(UIImage(named: "switchOn"), for: .normal)
                break
            default:
                break
            }
        }else {
            self.alertUser(title: "Error".localized, message: "An error has occurred".localized)
        }
    }
}
