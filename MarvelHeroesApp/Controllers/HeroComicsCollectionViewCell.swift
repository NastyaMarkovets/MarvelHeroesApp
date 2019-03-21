//
//  HeroComicsCollectionViewCell.swift
//  MarvelHeroesApp
//
//  Created by LocalUser on 21/03/2019.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import UIKit

class HeroComicsCollectionViewCell: UICollectionViewCell {
  
  static let reuseIdentifier = "cellComicsId"

  lazy var nameComicsLabel: UILabel = {
    let name = UILabel()
    name.text = ""
    name.textAlignment = .center
    name.textColor = UIColor(red: 66.0/255.0, green: 143.0/255.0, blue: 222.0/255.0, alpha: 1.0)
    name.font = UIFont(name: "HelveticaNeue-Medium", size: 12.0)
    return name
  }()
  
  lazy var imageComics: UIImageView = {
    let imageView = UIImageView()
    imageView.autoSetDimensions(to: CGSize(width: 100.0, height: 100.0))
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 50.0
    imageView.clipsToBounds = true
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .yellow
    contentView.addSubview(nameComicsLabel)
    contentView.addSubview(imageComics)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    imageComics.autoAlignAxis(toSuperviewAxis: .vertical)
    imageComics.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
    
    nameComicsLabel.autoAlignAxis(toSuperviewAxis: .vertical)
    nameComicsLabel.autoPinEdge(.top, to: .bottom, of: imageComics, withOffset: 2.0)
  }
}
