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

    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Lifecycle Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = nil
    }
}

// MARK: - Configure

extension DetailsShowTableViewCell {

    func configure(with item: Show) {
        descriptionLabel.text = item.description ?? "No text"
    }
}
