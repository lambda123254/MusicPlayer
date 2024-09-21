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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
