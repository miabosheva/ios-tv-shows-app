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
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var noReviewsView: UIView!
    @IBOutlet weak var reviewSummaryView: UIStackView!
    
    // MARK: - Lifecycle Methods
    
    override func awakeFromNib() {
        ratingView.configure(withStyle: .small)
        ratingView.isEnabled = false
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = nil
        showImage.image = nil
        ratingLabel.text = nil
    }
}

// MARK: - Configure

extension DetailsShowTableViewCell {
    
    func configure(with item: Show) {
        let imageUrl = URL(string: item.imageUrl)
        showImage.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "ic-show-placeholder-rectangle"))
        
        descriptionLabel.text = item.description ?? "No text"
        guard let noOfReviews = item.noOfReviews,
              let averageRating = item.averageRating else {
            reviewSummaryView.isHidden = true
            noReviewsView.isHidden = false
            return
        }
        
        let rating = Double(averageRating)
        ratingView.setRoundedRating(rating)
        ratingLabel.text = "\(noOfReviews) REVIEWS, \(averageRating) AVERAGE"
    }
}

// MARK: - Private

private extension DetailsShowTableViewCell {
    
    func setupUI() {
        showImage.layer.cornerRadius = 10
        showImage.layer.masksToBounds = true
        reviewSummaryView.isHidden = false
        noReviewsView.isHidden = true
    }
}
