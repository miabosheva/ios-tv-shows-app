//
//  TVShowsTableViewCell.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 26.7.23.
//

import Foundation
import UIKit

final class TVShowTableViewCell: UITableViewCell {

    // MARK: - Private UI

    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        showImage.image = nil
        titleLabel.text = nil
    }

}

// MARK: - Configure

extension TVShowTableViewCell {

    func configure(with item: Show) {
        titleLabel.text = item.title
    }
}

