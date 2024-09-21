//
//  LSView.swift
//  LaunchScreen
//
//  Created by Reza Mac on 21/09/24.
//

import UIKit

class LSView: UIViewController {
    
    var viewModel: LSViewModel?
    
    init() {
        super.init(nibName: String(describing: LSView.self), bundle: Bundle(for: LSView.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel?.navigateToHome()
        }
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
