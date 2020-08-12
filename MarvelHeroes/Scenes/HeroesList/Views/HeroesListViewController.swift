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
    
    private var viewModel: HeroesListViewModel
    private let disposeBag = DisposeBag()
    
    private let tableView = UITableView()
    private let spinner = UIActivityIndicatorView()
    private let searchController = UISearchController()
    
    var transitionImageView: UIImageView? {
        selectedCell?.thumbnailImageView
    }
    var selectedCell: HeroListCell?
        
    init(viewModel: HeroesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        
        let tableViewContraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let spinnerConstraints = [
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(tableViewContraints + spinnerConstraints)
        
        searchController.searchBar.placeholder = "Search for superheroes"
        navigationItem.searchController = searchController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Marvel Superheroes"
        
        setupTableView()
        setupBindings()
        
        viewModel.loadHeroes()
    }
    
    private func setupTableView() {
        tableView.registerCell(HeroListCell.self)

        let dataSource = RxTableViewSectionedAnimatedDataSource<Section>(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            let cell: HeroListCell = tableView.dequeueTableViewCell(for: indexPath)
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
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
                
        let cellSelectionTrigger = Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(CellViewModel.self))
        cellSelectionTrigger
            .subscribe(onNext: { [weak self] indexPath, model in
                let vm = HeroDetailViewModel(heroID: model.hero.id, service: MarvelAPIClient())
                let vc = HeroDetailViewController(viewModel: vm)
                vc.modalPresentationStyle = .custom
                vc.transitioningDelegate = self
                self?.selectedCell = self?.tableView.cellForRow(at: indexPath) as? HeroListCell
                self?.present(vc, animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        viewModel.isLoading.bind(to: spinner.rx.run).disposed(by: disposeBag)
        searchController.searchBar.rx.text.bind(to: viewModel.filterText).disposed(by: disposeBag)
    }
}

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
