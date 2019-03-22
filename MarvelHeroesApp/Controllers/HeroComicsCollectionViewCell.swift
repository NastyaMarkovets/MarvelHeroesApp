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

  lazy var nameComicsLabel: UILabel = {
    let name = UILabel()
    name.text = ""
    name.textAlignment = .center
    name.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
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
    backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
    contentView.addSubview(nameComicsLabel)
    contentView.addSubview(imageComics)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    imageComics.autoPinEdge(toSuperviewEdge: .top, withInset: 6)
    imageComics.autoPinEdge(toSuperviewEdge: .left, withInset: 6)
    imageComics.autoPinEdge(toSuperviewEdge: .right, withInset: 6)
    
    nameComicsLabel.autoPinEdge(.top, to: .bottom, of: imageComics, withOffset: 6.0)
    nameComicsLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 6)
    nameComicsLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 6)
    nameComicsLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 6)
    nameComicsLabel.autoSetDimension(.height, toSize: 20)
  }
}
