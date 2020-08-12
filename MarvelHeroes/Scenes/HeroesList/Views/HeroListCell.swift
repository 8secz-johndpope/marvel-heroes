//
//  Created by Pablo Balduz on 12/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import UIKit
import Kingfisher

class HeroListCell: UICollectionViewCell, ReusableCell {
        
    let thumbnailImageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        setupViews()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewModel(_ vm: CellViewModel) {
        nameLabel.text = vm.hero.name
        thumbnailImageView.kf.setImage(with: vm.hero.thumbnail.url)
    }
    
    // MARK: - Private
    
    private func setupViews() {
        contentView.backgroundColor = UIColor(r: 26, g: 70, b: 128, alpha: 0.5)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        nameLabel.numberOfLines = 0
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
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
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor)
        ]
        
        NSLayoutConstraint.activate(contentStackViewConstraints + imageViewConstraints)
    }
}
