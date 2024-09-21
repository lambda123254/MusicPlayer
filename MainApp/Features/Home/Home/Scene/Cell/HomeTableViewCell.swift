//
//  HomeTableViewCell.swift
//  Home
//
//  Created by Reza Mac on 21/09/24.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    static let string = String(describing: HomeTableViewCell.self)
    static let nib = UINib(nibName: string, bundle: Bundle(for: HomeTableViewCell.self))
    
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    
    private var circularProgressView: CircularProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCircularProgressView()
        startLoadingAnimation()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setupCircularProgressView() {
        circularProgressView = CircularProgressView()
        circularProgressView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(circularProgressView)
        NSLayoutConstraint.activate([
            circularProgressView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            circularProgressView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            circularProgressView.widthAnchor.constraint(equalToConstant: 42),
            circularProgressView.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    
    private func startLoadingAnimation() {
        var progress: CGFloat = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            progress += 0.01
            self.circularProgressView.progress = progress
            
            if progress >= 1 {
                timer.invalidate()
            }
        }
    }
    
}
