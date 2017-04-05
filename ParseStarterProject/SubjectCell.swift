//
//  SubjectCell.swift
//  PUProject
//
//  Created by August Lund Eilertsen on 15.02.2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

//This class is the custom view that appears in the subjectTableViews
class SubjectCell: UITableViewCell {

    @IBOutlet var labelSubjectCode: UILabel!
    @IBOutlet var labelSubjectName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
