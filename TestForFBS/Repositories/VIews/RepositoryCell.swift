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
    
    override func awakeFromNib() {
        super.awakeFromNib()
      // self можно опустить
        self.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.selectionStyle = .none
    }
    
}
