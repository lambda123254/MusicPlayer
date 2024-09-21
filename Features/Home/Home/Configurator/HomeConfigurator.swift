//
//  HomeConfigurator.swift
//  LaunchScreen
//
//  Created by Reza Mac on 21/09/24.
//

import UIKit

public class HomeConfigurator {
    public static let shared = HomeConfigurator()
    
    public func configureMainScreen() -> UIViewController {
        let view: HomeView = HomeView()
        let viewModel: HomeViewModel = HomeViewModel()
        view.viewModel = viewModel
        viewModel.view = view
        return view
    }
}
