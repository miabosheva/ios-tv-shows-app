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
        
        let rating = Double(item.averageRating ?? 0)
        ratingView.setRoundedRating(rating)
        ratingLabel.text = "\(item.noOfReviews ?? 0) REVIEWS, \(item.averageRating ?? 0) AVERAGE"
    }
}

// MARK: - Private

private extension DetailsShowTableViewCell {

    func setupUI() {
        showImage.layer.cornerRadius = 10
        showImage.layer.masksToBounds = true
    }
}
