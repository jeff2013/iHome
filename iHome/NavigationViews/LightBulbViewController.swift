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
    
    enum Light: Int{
        case mainLamp, deskLamp, moodLight
        
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
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var mainLampButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "greyGradient.jpg")!)
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
    }
    
    //toggles light on and off using the title of the button as a stateholder
    @IBAction func toggleLight(_ sender: UIButton) {
        if let light = Light(rawValue: sender.tag) {
            //No authentication for Light
            let auth = AuthModel(userName: nil, pass: nil)
            LightsService(authenticate: auth).toggle(lightName: light.stringInterpretation, toggle: LightToggle.off, auth: auth) { (lightname, lightToggle) in
                if let state = sender.titleLabel?.text, lightname != "Error"{
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
                } else {
                    self.alertUser(title: NSLocalizedString("Error", comment: "Error title"), message: NSLocalizedString("An error has occurred", comment: "The error message"))
                }
            }
        }
    }
}
