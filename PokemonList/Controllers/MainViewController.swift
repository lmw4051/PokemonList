//
//  MainViewController.swift
//  PokemonList
//
//  Created by David on 2020/11/17.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import MBProgressHUD

class MainViewController: UICollectionViewController {
  // MARK: - Properties
    private let reuseIdentifier = "PokemonCell"
    
    lazy var viewModel: PokemonViewModel = {
      return PokemonViewModel()
    }()
    
    var pokemons: [PokemonListQuery.Data.Pokemon] = []

    // MARK: - Lifecycle
    init() {
      super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      configureCollectionView()
      initVM()
    }
    
    // MARK: - Helpers
    func configureCollectionView() {
      navigationItem.title = "Pokemon"
      navigationController?.navigationBar.prefersLargeTitles = true
      
      collectionView.backgroundColor = .white
      collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: reuseIdentifier)
      
      configureCollectionViewFlowLayout()
    }
    
    func configureCollectionViewFlowLayout() {
      let itemSpace: CGFloat = 10
      let columnCount: CGFloat = 2
      let inset: CGFloat = 0
      let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
      let width = floor((collectionView.bounds.width - itemSpace * (columnCount - 1) - inset * 2) / columnCount)
      flowLayout?.itemSize = CGSize(width: width, height: width)
      flowLayout?.estimatedItemSize = .zero
      flowLayout?.minimumInteritemSpacing = itemSpace
      flowLayout?.minimumLineSpacing = itemSpace
      flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    func initVM() {
      viewModel.showAlertClosure = { [weak self] in
        DispatchQueue.main.async {
          if let message = self?.viewModel.alertMessage {
            self?.showErrorAlert(title: "Network Error", message: message)
          }
        }
      }
      
      viewModel.updateLoadingStatus = { [weak self] in
        guard let self = self else { return }
        
        DispatchQueue.main.async {
          if self.viewModel.isLoading {
            MBProgressHUD.showAdded(to: self.view, animated: true)
          } else {
            MBProgressHUD.hide(for: self.view, animated: true)
          }
        }
      }
      
      viewModel.reloadCollectionViewClosure = { [weak self] in
        self?.collectionView.reloadData()
      }
      
      viewModel.initFetch()
    }
    
    private func showErrorAlert(title: String, message: String) {
      let alert = UIAlertController(title: title,
                                    message: message,
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }

  // MARK: - UICollectionViewDataSource
  extension MainViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return viewModel.numberOfCells
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PokemonCell
      let cellVM = viewModel.getCellViewModel(at: indexPath)
      cell.pokemonCellVM = cellVM
      return cell
    }
  }
