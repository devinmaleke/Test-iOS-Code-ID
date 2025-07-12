//
//  HomeVC.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 09/07/25.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import RxCocoa

class HomeVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = HomeVM()
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        bindViewModel()
        viewModel.refreshPokemons()
        
        searchBar.delegate = self
    }
    
    private func setTableView(){
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib(nibName: "HomeListTVC", bundle: nil), forCellReuseIdentifier: "HomeListTVC")
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.refreshControl = refreshControl
        
        // Pull to Refresh
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.searchBar.text = ""
                self?.viewModel.searchQuery.accept("")
                self?.viewModel.refreshPokemons()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel.filteredPokemons
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "HomeListTVC", cellType: HomeListTVC.self)) { row, model, cell in
                cell.setup(pokemon: model.name.capitalized)
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                self?.showErrorToast(message: message)
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] loading in
                print("Loading: \(loading)")
                if loading {
                    self?.showLoading()
                } else {
                    self?.hideLoading()
                    self?.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(PokemonListItem.self)
            .subscribe(onNext: { [weak self] pokemon in
                let detailVC = HomeDetailVC(name: pokemon.name)
                self?.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }}

extension HomeVC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
        return IndicatorInfo(title: "Home")
    }
}

extension HomeVC: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y >= 0 else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 100 {
            viewModel.fetchPokemons(isLoadMore: true)
        }
    }
}

extension HomeVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchQuery.accept(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.searchQuery.accept("")
        searchBar.resignFirstResponder()
    }
}
