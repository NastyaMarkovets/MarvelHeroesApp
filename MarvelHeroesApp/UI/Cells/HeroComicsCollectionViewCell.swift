//
//  HeroComicsCollectionViewCell.swift
//  MarvelHeroesApp
//
//  Created by LocalUser on 21/03/2019.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import UIKit
import Kingfisher

class HeroComicsCollectionViewCell: UICollectionViewCell {
  
  static let reuseIdentifier = "cellComicsId"
  
  private enum Dimensions {
    static let inset: CGFloat = 6
    static let sizeTitle: CGFloat = 20
  }

  lazy var nameComicsLabel: UILabel = {
    let name = UILabel()
    name.text = ""
    name.textAlignment = .center
    name.font = UIFont.fontHelveticaMedium(size: 14.0)
    return name
  }()
  
  lazy var imageComics: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor(white: 0.9, alpha: 1)
    contentView.addSubview(nameComicsLabel)
    contentView.addSubview(imageComics)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    imageComics.autoPinEdge(toSuperviewEdge: .top, withInset: Dimensions.inset)
    imageComics.autoPinEdge(toSuperviewEdge: .left, withInset: Dimensions.inset)
    imageComics.autoPinEdge(toSuperviewEdge: .right, withInset: Dimensions.inset)
    
    nameComicsLabel.autoPinEdge(.top, to: .bottom, of: imageComics, withOffset: Dimensions.inset)
    nameComicsLabel.autoPinEdge(toSuperviewEdge: .left, withInset: Dimensions.inset)
    nameComicsLabel.autoPinEdge(toSuperviewEdge: .right, withInset: Dimensions.inset)
    nameComicsLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: Dimensions.inset)
    nameComicsLabel.autoSetDimension(.height, toSize: Dimensions.sizeTitle)
  }
}
