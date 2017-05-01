//
//  ViewController.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-01.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var MenuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuButton.target = revealViewController();
        MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

