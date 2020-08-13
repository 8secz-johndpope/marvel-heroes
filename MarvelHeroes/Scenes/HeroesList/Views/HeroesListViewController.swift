//
//  Created by Pablo Balduz on 07/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import MarvelHeroesKit

class HeroesListViewController: UIViewController, ImageTransitionAnimatorDelegate {
    
    typealias Section = AnimatableSectionModel<String, CellViewModel>
    
    weak var coordinator: HeroesCoordinator?
    
    private var viewModel: HeroesListViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var layout = ColumnFlowLayout(containerWidth: view.bounds.size.width)
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private let spinner = UIActivityIndicatorView()
    private let searchController = UISearchController()
    
    var transitionImageView: UIImageView? {
        selectedCell?.thumbnailImageView
    }
    private var selectedCell: HeroListCell?
        
    init(viewModel: HeroesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        
        let collectionViewContraints = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let spinnerConstraints = [
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(collectionViewContraints + spinnerConstraints)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Marvel Superheroes"
        view.backgroundColor = .white
        
        setupSearchController()
        setupCollectionView()
        setupBindings()
        
        viewModel.loadHeroes()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout.containerWidth = view.safeAreaLayoutGuide.layoutFrame.size.width
        layout.columnCount = self.view.traitCollection.horizontalSizeClass == .compact ? 1 : 2
    }
    
    // MARK: - Private
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "Search for superheroes"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.registerCell(HeroListCell.self)
        
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<Section>(configureCell: { dataSource, collectionView, indexPath, item -> UICollectionViewCell in
            let cell: HeroListCell = collectionView.dequeueCollectionViewCell(for: indexPath)
            cell.setViewModel(item)
            return cell
        })

        dataSource.animationConfiguration = AnimationConfiguration(
            insertAnimation: .fade,
            reloadAnimation: .automatic,
            deleteAnimation: .fade)

        let sections: Observable<[Section]> = viewModel.state.map { state in
            switch state {
            case .empty:
                return []
            case let .list(heroes):
                return [
                    AnimatableSectionModel(
                        model: "Superheroes",
                        items: heroes)
                ]
            }
        }

        sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        let cellSelectionTrigger = Observable.zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(CellViewModel.self))
        cellSelectionTrigger
            .subscribe(onNext: { [weak self] indexPath, model in
                guard let self = self else { return }
                self.selectedCell = self.collectionView.cellForItem(at: indexPath) as? HeroListCell
                self.coordinator?.showHeroDetail(id: model.hero.id, transitioningDelegate: self)
            }).disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        viewModel.isLoading.bind(to: spinner.rx.run).disposed(by: disposeBag)
        searchController.searchBar.rx.text.bind(to: viewModel.filterText).disposed(by: disposeBag)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension HeroesListViewController: UIViewControllerTransitioningDelegate {
        
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let presentedVC = presented as? HeroDetailViewController else {
            return nil
        }
        return ImageTransitionAnimator(kind: .presentation, presentingDelegate: self, presentedDelegate: presentedVC)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let presentedVC = dismissed as? HeroDetailViewController else {
            return nil
        }
        return ImageTransitionAnimator(kind: .dismissal, presentingDelegate: self, presentedDelegate: presentedVC)
    }
}
