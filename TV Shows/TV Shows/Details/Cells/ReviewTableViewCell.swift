//
//  ReviewTableViewCell.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 27.7.23.
//

import Foundation
import UIKit

final class ReviewTableViewCell : UITableViewCell {
    
    // MARK: - Private UI
    
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var userThumbnail: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    // MARK: - Lifecycle Methods
    
    override func awakeFromNib() {
        ratingView.configure(withStyle: .small)
        ratingView.isEnabled = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userThumbnail.image = nil
        usernameLabel.text = nil
        reviewLabel.text = nil
    }
}

// MARK: - Configure

extension ReviewTableViewCell {

    func configure(with item: Review) {
        usernameLabel.text = item.user.email
        reviewLabel.text = item.comment
        ratingView.setRoundedRating(Double(item.rating))
    }
}

