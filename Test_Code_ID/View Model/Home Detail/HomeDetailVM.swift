//
//  HomeDetailVM.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 11/07/25.
//

import RxSwift
import RxRelay

class HomeDetailVM {
    let pokemonDetail = PublishRelay<PokemonDetailModel>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = PublishRelay<String>()
    
    private let disposeBag = DisposeBag()
    
    func fetchPokemonDetail(name: String) {
        isLoading.accept(true)
        NetworkService.shared.requestObservable(
            url: "pokemon/\(name.lowercased())",
            method: .get,
            responseType: PokemonDetailModel.self
        )
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] detail in
            self?.isLoading.accept(false)
            self?.pokemonDetail.accept(detail)
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self.isLoading.accept(false)
            
            if let netError = error as? NetworkError {
                switch netError {
                case .apiError(let msg):
                    self.errorMessage.accept(msg)
                case .decodingError(let err):
                    self.errorMessage.accept("Decode Error: \(err.localizedDescription)")
                case .urlError(let urlErr):
                    self.errorMessage.accept("URL Error: \(urlErr.localizedDescription)")
                case .unknown(_, let err):
                    self.errorMessage.accept("Error: \(err.localizedDescription)")
                }
            } else {
                self.errorMessage.accept(error.localizedDescription)
            }
        })
        .disposed(by: disposeBag)
    }
}
