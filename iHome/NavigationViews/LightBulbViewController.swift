//
//  HomeViewController.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-02.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import UIKit
import SWRevealViewController
import Alamofire

class LightBulbViewController: UIViewController {
    
    enum Light: Int{
        case mainLamp, deskLamp, moodLight
        
        func stringInterpretation()->String {
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
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
    }
    
    //toggles light on and off using the title of the button as a stateholder
    @IBAction func toggleLight(_ sender: UIButton) {
        if let light = Light(rawValue: sender.tag) {
            toggle(lightName: light.stringInterpretation(), toggle: LightToggle.off) { (lightname, lightToggle) in
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

// MARK: - Networking calls
extension LightBulbViewController {
    func toggle(lightName: String, toggle: LightToggle, completion: @escaping(String, LightToggle)->Void){
        Alamofire.request(NetworkRouter.toggleLight(lightName, toggle)).responseJSON { response in
            guard response.result.isSuccess else{
                //an error has happened
                completion("Error", LightToggle.off)
                return
            }
            guard let responseJSON = response.result.value as? [String: Any],
            let results = responseJSON["results"] as? [String: Any],
            let lightName = results["lightName"] as? String,
            let toggleString = results["toggle"] as? String,
            let toggle = LightToggle(rawValue: toggleString) else {
                //invalid data returned
                completion("Error", LightToggle.off)
                return
            }
            completion(lightName, toggle)
        }
    }
}
