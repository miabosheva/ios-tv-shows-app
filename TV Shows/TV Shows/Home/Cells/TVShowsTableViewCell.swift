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

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }

}

// MARK: - Configure

extension TVShowTableViewCell {

    func configure(with item: Show) {
        titleLabel.text = item.title
    }
}
