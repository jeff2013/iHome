//
//  MenuViewController.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-01.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import UIKit
import SWRevealViewController

class MenuViewController: UIViewController {
    enum Title: Int{
        case home, lights, blinds, logout, count
        
        var description: String{
            switch self{
            case .home:
                return "Home"
            case .lights:
                return "Lights"
            case .blinds:
                return "Blinds"
            case .logout:
                return "Logout"
            default:
                return "Default"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

//MARK: - MenuUITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Title.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellIdentifier") as! TableCell
        let titleSelected = Title(rawValue: indexPath.row)!.description
        
        cell.titleLabel.text = titleSelected
        cell.icon.image = UIImage(named: titleSelected.lowercased())
        return cell
    }
}

//MARK: - MenuUITableViewDelegate
extension MenuViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Title(rawValue: indexPath.row)!.rawValue{
        case Title.home.rawValue:
            switchControllerFor(name: "Main", identifier: "HomeController", animated: true)
            break
        case Title.lights.rawValue:
            switchControllerFor(name: "Main", identifier: "LightBulbViewController", animated: true)
            break
        case Title.blinds.rawValue:
            switchControllerFor(name: "Main", identifier: "BlindsViewController", animated: true)
        case Title.logout.rawValue:
            replaceRootController(storyBoard: "Main", storyBoardIdentifier: "LoginViewController", duration: 0.3, transition: .transitionFlipFromRight, completion: {})
            //removes authentication token
            KeychainService.deleteToken()
        default:
            break
        }
    }
    
    private func switchControllerFor(name: String, identifier: String, animated: Bool) {
        let revealViewController:SWRevealViewController = self.revealViewController()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: name, bundle: nil)
        let destinationController = mainStoryboard.instantiateViewController(withIdentifier: identifier)
        let newFrontController = UINavigationController.init(rootViewController: destinationController)
        revealViewController.pushFrontViewController(newFrontController, animated: animated)
    }
}
