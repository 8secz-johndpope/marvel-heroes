//
//  Created by Pablo Balduz on 12/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import UIKit
import Kingfisher

class HeroListCell: UITableViewCell {
    
    static let ReuseID = "hero-list-cell"
    
    let thumbnailImageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewModel(_ vm: CellViewModel) {
        nameLabel.text = vm.hero.name
        thumbnailImageView.kf.setImage(with: vm.hero.thumbnail.url)
    }
    
    private func layout() {
        let contentStackView = UIStackView(arrangedSubviews: [thumbnailImageView, nameLabel])
        contentStackView.spacing = 10
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentStackView)
        
        let contentStackViewConstraints = [
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        let imageViewConstraints = [
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(contentStackViewConstraints + imageViewConstraints)
    }
}
