//
//  MenuCell.swift
//  DropDownMenu
//
//  Created by Nirzar Gandhi on 18/05/25.
//

import UIKit

class MenuCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomSeparator: UIView!
    
    
    // MARK: - Cell init methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        // Title Label
        self.titleLabel.backgroundColor = .clear
        self.titleLabel.textColor = .white
        self.titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.titleLabel.textAlignment = .left
        self.titleLabel.numberOfLines = 1
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.text = ""
        
        // Bottom Separator
        self.bottomSeparator.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 0.1)
    }
    
    
    // MARK: - Cell Configuration
    func configureCell(item: String?,
                       isSeparatorHide: Bool,
                       isSelected: Bool = false) {
        
        // Title Label
        self.titleLabel.text = ""
        if let title = item, !title.isEmpty {
            self.titleLabel.text = title
        }
        
        if isSelected {
            self.titleLabel.textColor = .white
            self.titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        } else {
            self.titleLabel.textColor = UIColor.white.withAlphaComponent(0.6)
            self.titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
        
        // Bottom Separator
        self.bottomSeparator.isHidden = isSeparatorHide
    }
}
