//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Reza Mac on 21/09/24.
//

import UIKit
import AppNavigation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AppNavigation.shared.initialLaunch(view: self)
    }

}

