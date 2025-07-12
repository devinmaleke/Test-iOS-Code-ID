//
//  HomeVM.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 11/07/25.
//

import RxSwift
import RxRelay

class HomeVM {
    
    private let disposeBag = DisposeBag()
    
    let pokemons = BehaviorRelay<[PokemonListItem]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = PublishRelay<String>()
    
    private var offset = 0
    private let limit = 10
    private var isLastPage = false
    
    let searchQuery = BehaviorRelay<String>(value: "")
    let filteredPokemons = BehaviorRelay<[PokemonListItem]>(value: [])
    
    init() {
         bindSearchQuery()
     }
    
    private func bindSearchQuery() {
        Observable.combineLatest(pokemons, searchQuery)
            .map { pokemons, query -> [PokemonListItem] in
                guard !query.isEmpty else { return pokemons }
                return pokemons.filter { $0.name.lowercased().contains(query.lowercased()) }
            }
            .bind(to: filteredPokemons)
            .disposed(by: disposeBag)
    }
    
    func fetchPokemons(isLoadMore: Bool = false) {
        guard !isLoading.value, !isLastPage else { return }
        
        if !isLoadMore && offset != 0 {
            offset = 0
        }
    
        isLoading.accept(true)
        
        NetworkService.shared.requestObservable(
            url: "pokemon?limit=\(limit)&offset=\(offset)",
            method: .get,
            responseType: PokemonListModel.self
        )
        .observe(on: MainScheduler.instance)
        .subscribe(
            onNext: { [weak self] response in
                guard let self = self else { return }
                
                if response.results.isEmpty {
                    self.isLastPage = true
                }
                
                let newData = isLoadMore ? self.pokemons.value + response.results : response.results
                self.pokemons.accept(newData)
                
                self.offset += self.limit
                self.isLoading.accept(false)
            },
            onError: { [weak self] error in
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
            }
        )
        .disposed(by: disposeBag)
    }
    
    func refreshPokemons() {
        offset = 0
        isLastPage = false
        filteredPokemons.accept([])
        pokemons.accept([])
        fetchPokemons(isLoadMore: false)
    }
}
