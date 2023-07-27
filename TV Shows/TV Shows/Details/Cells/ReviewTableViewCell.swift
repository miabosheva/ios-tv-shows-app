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

extension ReviewTableViewCell {

    func configure(with item: Show) {
        let url = URL(string: item.imageUrl)
            if let data = try? Data(contentsOf: url!)
            {
                let image: UIImage = UIImage(data: data) ?? UIImage(named: "icImagePlaceholder")!
                showImage.image = image
            }
        titleLabel.text = item.title
    }
}

// MARK: - Private

private extension ReviewTableViewCell {

    func setupUI() {
        showImage.layer.cornerRadius = 5
        showImage.layer.masksToBounds = true
    }
}


