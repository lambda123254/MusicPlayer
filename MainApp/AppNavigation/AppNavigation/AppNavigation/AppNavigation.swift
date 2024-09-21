//
//  AppNavigation.swift
//  AppNavigation
//
//  Created by Reza Mac on 21/09/24.
//

import UIKit
import LaunchScreen
import Home

public class AppNavigation {
    
    public static let shared = AppNavigation()
    
    weak var delegate: AppNavigationDelegate?
    
    public init(){
        LSRouter.shared.delegate = self
    }
    
    public func initialLaunch(view: UIViewController) {
        let nextVC = LSConfigurator.shared.configureMainScreen()
        view.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

extension AppNavigation: LSRouterProtocol {
    
    public func navigateToHome(view: UIViewController) {
        let nextVC = HomeConfigurator.shared.configureMainScreen()
        view.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
