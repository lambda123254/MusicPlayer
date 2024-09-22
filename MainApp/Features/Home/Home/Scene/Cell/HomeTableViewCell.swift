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
    @IBOutlet weak var playButton: UIButton!
    
    private var circularProgressView: CircularProgressView?
    private var timer: Timer?
    
    public var trackId: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCircularProgressView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setupCircularProgressView() {
        circularProgressView = CircularProgressView()
        if let circularProgressView = circularProgressView {
            circularProgressView.isHidden = true
            circularProgressView.minValue = .zero
            circularProgressView.maxValue = 30
            circularProgressView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(circularProgressView)
            NSLayoutConstraint.activate([
                circularProgressView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                circularProgressView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
                circularProgressView.widthAnchor.constraint(equalToConstant: 42),
                circularProgressView.heightAnchor.constraint(equalToConstant: 42)
            ])
        }
        
    }
    
    
    func updateProgress(maxProgress: CGFloat, currentDuration: CGFloat? = nil) {
        if let circularProgressView = circularProgressView {
            circularProgressView.progress = currentDuration ?? .zero
            circularProgressView.isHidden = false
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {[weak self] timer in
                let circularProgress = circularProgressView.progress
                circularProgressView.progress += 1
                if circularProgress >= maxProgress {
                    timer.invalidate()
                }
            }
        }
        
    }
    
    func stopUpdatingProgress() {
        if let circularProgressView = circularProgressView {
            circularProgressView.isHidden = true
            circularProgressView.progress = .zero
            timer?.invalidate()
            timer = nil
        }
    }
    
    func pauseUpdatingProgress() {
        if let circularProgressView = circularProgressView {
            circularProgressView.isHidden = true
            circularProgressView.progress = .zero
            timer?.invalidate()
        }
    }
    
}
