//
//  MenuViewController.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-01.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import UIKit
import SWRevealViewController

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    enum Titles: String{
        case Home, Lights, Blinds, Logout
        
        //Not sure what the best way of providing an iterable way...
        static let allValues = [Home, Lights, Blinds, Logout]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Titles.allValues.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellIdentifier") as! TableCell
        let titleSelected = Titles.allValues[indexPath.row].rawValue
        
        cell.titleLabel.text = titleSelected
        cell.icon.image = UIImage(named: titleSelected.lowercased())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: TableCell = tableView.cellForRow(at: indexPath) as! TableCell
        switch Titles(rawValue: cell.titleLabel.text!)!{
            case .Home:
                switchControllerFor(name: "Main", identifier: "HomeController", animated: true)
                break
            case .Lights:
                switchControllerFor(name: "Main", identifier: "LightBulbViewController", animated: true)
            break
            default:
                break
        }
    }
    
    func switchControllerFor(name: String, identifier: String, animated: Bool){
        let revealViewController:SWRevealViewController = self.revealViewController()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: name, bundle: nil)
        let destinationController = mainStoryboard.instantiateViewController(withIdentifier: identifier)
        let newFrontController = UINavigationController.init(rootViewController: destinationController)
        revealViewController.pushFrontViewController(newFrontController, animated: animated)
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
