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
    @IBOutlet weak var showImage: UIImageView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        showImage.image = nil
        descriptionLabel.text = nil
    }

}

// MARK: - Configure

extension DetailsShowTableViewCell {

    func configure(with item: Show) {
        
//        print(showImage.image as Any)
        descriptionLabel.text = item.description ?? "No text"
        print(descriptionLabel.text as Any)
    }
}

// MARK: - Private

private extension DetailsShowTableViewCell {

    func setupUI() {
//        showImage.layer.cornerRadius = 5
//        showImage.layer.masksToBounds = true
    }
}

