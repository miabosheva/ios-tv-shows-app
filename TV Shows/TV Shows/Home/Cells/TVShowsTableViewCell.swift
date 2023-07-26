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

//    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

//        thumbnailImageView.image = nil
        titleLabel.text = nil
    }

}

// MARK: - Configure

extension TVShowTableViewCell {

    func configure(with item: Show) {
        titleLabel.text = item.title
    }
}

// MARK: - Private

private extension TVShowTableViewCell {

    func setupUI() {
//        thumbnailImageView.layer.cornerRadius = 20
//        thumbnailImageView.layer.masksToBounds = true
    }
}
