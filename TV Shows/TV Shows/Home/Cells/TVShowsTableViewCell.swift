//
//  TVShowsTableViewCell.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 26.7.23.
//

import Foundation
import UIKit
import Kingfisher

final class TVShowTableViewCell: UITableViewCell {

    // MARK: - Private UI

    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        showImage.image = nil
        titleLabel.text = nil
    }

}

// MARK: - Configure

extension TVShowTableViewCell {

    func configure(with item: Show) {
        let imageUrl = URL(string: item.imageUrl)
        showImage.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "ic-show-placeholder-vertical"))
        titleLabel.text = item.title
    }
}

// MARK: - Private

private extension TVShowTableViewCell {

    func setupUI() {
        showImage.layer.cornerRadius = 10
        showImage.layer.masksToBounds = true
    }
}

