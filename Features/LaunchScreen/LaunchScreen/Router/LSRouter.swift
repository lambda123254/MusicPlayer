//
//  LSNavigation.swift
//  LaunchScreen
//
//  Created by Reza Mac on 21/09/24.
//

import UIKit

public class LSRouter {
    public static let shared = LSRouter()
    
    public weak var delegate: LSRouterProtocol?
    
    func navigateToHome(view: UIViewController) {
        delegate?.navigateToHome(view: view)
    }

}
