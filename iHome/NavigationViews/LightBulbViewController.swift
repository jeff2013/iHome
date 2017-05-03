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
    
    enum Light{
        case mainLamp(String, Bool), deskLamp(String, Bool)
    }
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var mainLampButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        // Do any additional setup after loading the view.
    }
    @IBAction func toggleLight(_ sender: UIButton) {
        if let state = sender.titleLabel?.text {
            switch state {
            case "on":
                sender.setImage(UIImage(named: "switchOff"), for: .normal)
                break
            case "off":
                sender.setImage(UIImage(named: "switchOn"), for: .normal)
                break
            default:
                break
            }
            
        }

//        toggle(lightName: "test", toggle: LightToggle.off) { (lightname, lightToggle) in
//        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: - Networking calls
extension LightBulbViewController {
    func toggle(lightName: String, toggle: LightToggle, completion: @escaping(String, LightToggle)->Void){
        //maybe verify inputs
        let toggleLight = NetworkRouter.toggleLight(lightName, toggle)
        Alamofire.request(toggleLight).responseJSON { response in
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
