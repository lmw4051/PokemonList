//
//  PokemonViewModel.swift
//  PokemonList
//
//  Created by David on 2020/11/17.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation
import Apollo

class PokemonViewModel {
  // MARK: - Properties
  private var pokemons: [PokemonListQuery.Data.Pokemon] = []
  private var cellVMs = [PokemonCellViewModel]() {
    didSet {
      self.reloadCollectionViewClosure?()
    }
  }
  
  var isLoading: Bool = false {
    didSet {
      self.updateLoadingStatus?()
    }
  }
  
  var alertMessage: String? {
    didSet {
      self.showAlertClosure?()
    }
  }
  
  var numberOfCells: Int {
    return cellVMs.count
  }
  
  var reloadCollectionViewClosure: (() -> ())?
  var updateLoadingStatus: (() -> ())?
  var showAlertClosure: (() -> ())?
  
  // MARK: - Helpers
  func initFetch() {
    
    self.isLoading = true
    
    Network.shared.apollo.fetch(query: PokemonListQuery()) { result in
      self.isLoading = false
      
      switch result {
      case .success(let graphQLResult):
        print("Success! Result: \(graphQLResult)")
        if let pokemons = graphQLResult.data?.pokemons?.compactMap({ $0 }) {
          self.fetchedPokemon(pokemons: pokemons)
        }
      case .failure(let error):
        print("Failure! Error: \(error)")
        self.alertMessage = error.localizedDescription
      }
    }
  }
  
  private func fetchedPokemon(pokemons: [PokemonListQuery.Data.Pokemon]) {
    self.pokemons = pokemons
    var viewModels = [PokemonCellViewModel]()
    for pokemon in pokemons {
      viewModels.append(createCellViewModel(pokemon: pokemon))
    }
    self.cellVMs = viewModels
  }
  
  private func createCellViewModel(pokemon: PokemonListQuery.Data.Pokemon) -> PokemonCellViewModel {
    return PokemonCellViewModel(number: pokemon.number ?? "",
                                name: pokemon.name ?? "",
                                image: pokemon.image ?? "")
  }
  
  func getCellViewModel(at indexPath: IndexPath) -> PokemonCellViewModel {
    return cellVMs[indexPath.row]
  }
}

struct PokemonCellViewModel {
  let number: String
  let name: String
  let image: String
}
