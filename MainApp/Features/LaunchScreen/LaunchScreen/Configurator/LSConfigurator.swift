//
//  LSConfigurator.swift
//  LaunchScreen
//
//  Created by Reza Mac on 21/09/24.
//

import UIKit

public class LSConfigurator {
    public static let shared = LSConfigurator()
        
    public func configureMainScreen() -> UIViewController {
        let view: LSView = LSView()
        let viewModel: LSViewModel = LSViewModel()
        view.viewModel = viewModel
        viewModel.view = view
        return view
    }
}
