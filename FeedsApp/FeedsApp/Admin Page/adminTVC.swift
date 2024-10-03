//
//  adminTVC.swift
//  FeedsApp
//
//  Created by Jon Snow on 01/10/24.
//

import UIKit

class adminTVC: UITableViewCell {
    @IBOutlet weak var postLbl: UILabel!
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var CreatedbyLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
