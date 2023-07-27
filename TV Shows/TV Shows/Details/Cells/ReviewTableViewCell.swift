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

    @IBOutlet weak var reviewLabel: UILabel!
    
    // MARK: - Lifecycle Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reviewLabel.text = nil
    }
}

// MARK: - Configure

extension ReviewTableViewCell {

    func configure(with item: Review) {
        reviewLabel.text = item.comment
    }
}

