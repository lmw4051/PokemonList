//
//  PokemonCell.swift
//  PokemonList
//
//  Created by David on 2020/11/17.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import SDWebImage

class PokemonCell: UICollectionViewCell {
  // MARK: - Properties
  var pokemonCellVM: PokemonCellViewModel? {
    didSet {
      thumbnailImageView.sd_setImage(with: URL(string: pokemonCellVM?.image ?? ""))
      let numberStr = pokemonCellVM?.number ?? ""
      let nameStr = pokemonCellVM?.name ?? ""
      numberAndNameLabel.text = numberStr + " - " + nameStr
    }
  }
  
  // MARK: - UI Properties
  private lazy var thumbnailImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    return iv
  }()
  
  private lazy var alphaView: UIView = {
    let view = UIView()
    view.alpha = 0.5
    view.backgroundColor = UIColor.black
    return view
  }()
  
  private let numberAndNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = .boldSystemFont(ofSize: 16)
    label.textAlignment = .left
    label.lineBreakMode = .byTruncatingTail
    return label
  }()
    
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(thumbnailImageView)
    thumbnailImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 30, paddingLeft: 30, paddingBottom: 30, paddingRight: 30)
    
    addSubview(alphaView)
    alphaView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 0.3 * frame.height)
    
    alphaView.addSubview(numberAndNameLabel)
    numberAndNameLabel.anchor(top: alphaView.topAnchor, left: alphaView.leftAnchor, bottom: alphaView.bottomAnchor, right: alphaView.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 8, paddingRight: 4)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.thumbnailImageView.image = nil
  }
}

