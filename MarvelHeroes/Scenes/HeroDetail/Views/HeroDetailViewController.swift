//
//  Created by Pablo Balduz on 10/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class HeroDetailViewController: StretchyHeaderViewController {
    
    private var viewModel: HeroDetailViewModel
    private let disposeBag = DisposeBag()
    
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let spinner = UIActivityIndicatorView()
    private let closeButton = UIButton(type: .system)
    
    init(viewModel: HeroDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
            
        let contentStackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel])
        contentStackView.axis = .vertical
        contentStackView.spacing = 24
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentStackView)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        let contentStackViewConstraints = [
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        let spinnerConstraints = [
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        let closeButtonConstraints = [
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(contentStackViewConstraints + spinnerConstraints + closeButtonConstraints)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentView()
        setupBindings()
        
        closeButton.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.tintColor = .black
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.boldSystemFont(ofSize: 32)
        descriptionLabel.numberOfLines = 0
        
        viewModel.loadDetail()
        
        headerImageView.kf.setImage(with: URL.init(fileURLWithPath: "http:/i.annihil.us/u/prod/marvel/i/mg/6/20/52602f21f29ec.jpg"))
    }
    
    private func setupContentView() {
        view.backgroundColor = .white
        contentView.backgroundColor = .white
        contentView.backgroundColor = .white
        contentViewTopOffset = 20
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setupBindings() {
        viewModel.state
            .filterDetailState()
            .compactMap { $0.detail?.name }
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state
            .filterDetailState()
            .compactMap { $0.detail?.description }
            .map { $0 == "" ? loremIpsumText : $0 }
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state
            .filterDetailState()
            .compactMap { $0.detail?.thumbnail.url }
            .bind { [weak self] in
                self?.headerImageView.kf.setImage(with: $0)
            }.disposed(by: disposeBag)
        
        viewModel.isLoading
            .bind(to: spinner.rx.run)
            .disposed(by: disposeBag)
        
        closeButton.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
}

// Just to be able to see the layout fully working due to the short descriptions of the heroes. I is only added if description is empty
private var loremIpsumText: String {
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
}
