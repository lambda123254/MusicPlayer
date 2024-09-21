//
//  LSViewModel.swift
//  LaunchScreen
//
//  Created by Reza Mac on 21/09/24.
//

import UIKit

class LSViewModel {
    weak var view: LSView?
    
    func navigateToHome() {
        guard let view = view else {return}
        LSRouter.shared.navigateToHome(view: view)
    }
}
