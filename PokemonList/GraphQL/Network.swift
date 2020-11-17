//
//  Network.swift
//  PokemonList
//
//  Created by David on 2020/11/17.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation
import Apollo

class Network {
  static let shared = Network()
  
  private(set) lazy var apollo = ApolloClient(url: URL(string: "https://graphql-pokemon2.vercel.app/")!)
}
