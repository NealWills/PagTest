//
//  NameTableViewCell.swift
//  PagLayerNameTest
//
//  Created by Neal on 2022/11/2.
//

import UIKit

class NameTableViewCell: UITableViewCell {

    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
