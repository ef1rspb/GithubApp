//
//  RepositoryCell.swift
//  TestForFBS
//
//  Created by Mikhail Kuzmin on 25.12.2019.
//  Copyright © 2019 afldjakfj. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {
    
    static let id = "RepositoryCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var stargazersLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.selectionStyle = .none
    }
    
}
