//
//  RepositoryTableViewCell.swift
//  GithubSearch
//
//  Created by rowkaxl on 2021/06/13.
//

import UIKit
import Kingfisher

class RepositoryTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var stargazersCountLabel: UILabel!
    @IBOutlet private weak var updatedAtLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(item: RepositoryModel.Item) {
        
        if let urlString = item.owner?.avatarURL {
            avatarImageView.kf.setImage(with: URL(string: urlString),
                                        options: [.transition(ImageTransition.fade(0.2))])
        }
        stargazersCountLabel.text = "repository: \(item.stargazersCount)"
        updatedAtLabel.text = "updatedAt: \(item.updatedAt)"
        languageLabel.text = "language: \(item.language ?? "")"
    }
}
