//
//  HomeDetailVC.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 11/07/25.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class HomeDetailVC: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var abilitiesValue: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    private let pokemonName: String
    
    private let viewModel = HomeDetailVM()
    private let disposeBag = DisposeBag()
    
    
    init(name: String) {
        self.pokemonName = name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.fetchPokemonDetail(name: pokemonName)
        
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        if sender == backButton {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func bindViewModel() {
        viewModel.pokemonDetail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] detail in
                guard let self = self else { return }
                abilitiesValue.text = detail.abilities
                    .map { $0.ability.name }
                    .joined(separator: ", ")
                
                if let url = URL(string: detail.sprites.front_default ?? "") {
                    imageView.kf.setImage(with: url)
                }
                
                nameLabel.text = detail.name.capitalized
                
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                self?.showErrorToast(message: message)
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] loading in
                if loading {
                    self?.showLoading()
                } else {
                    self?.hideLoading()
                }
            })
            .disposed(by: disposeBag)
    }
}
