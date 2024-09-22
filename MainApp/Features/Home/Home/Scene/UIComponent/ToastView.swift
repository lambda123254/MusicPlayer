//
//  ToastView.swift
//  Home
//
//  Created by Reza Mac on 22/09/24.
//

import UIKit

class ToastView: UIView {
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(message: String) {
        super.init(frame: .zero)
        setupView(message: message)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView(message: String) {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        layer.cornerRadius = 8
        clipsToBounds = true
        
        addSubview(messageLabel)
        messageLabel.text = message
        
        // Set constraints for message label
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        // Size of the toast
        self.translatesAutoresizingMaskIntoConstraints = false
        self.alpha = 0
    }
    
    func show(in view: UIView, duration: TimeInterval) {
        view.addSubview(self)
        
        // Constraints for the toast
        NSLayoutConstraint.activate([
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        // Animate appearance
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1
        }) { _ in
            // Animate disappearance
            UIView.animate(withDuration: 0.5, delay: duration, options: [], animations: {
                self.alpha = 0
            }) { _ in
                self.removeFromSuperview()
            }
        }
    }
}
