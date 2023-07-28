//
//  DetailsShowTableViewCell.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 27.7.23.
//

import Foundation
import UIKit

final class DetailsShowTableViewCell: UITableViewCell {

    // MARK: - Private UI

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Lifecycle Methods
    
    override func awakeFromNib() {
        ratingView.configure(withStyle: .small)
        ratingView.isEnabled = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = nil
        ratingLabel.text = nil
    }
}

// MARK: - Configure

extension DetailsShowTableViewCell {

    func configure(with item: Show) {
        descriptionLabel.text = item.description ?? "No text"
        var rating = Double(item.averageRating ?? 0)
        ratingView.setRoundedRating(rating)
        ratingLabel.text = "\(item.noOfReviews ?? 0) REVIEWS, \(item.averageRating ?? 0) AVERAGE"
    }
}
