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
    name.font = UIFont(name: "HelveticaNeue-Medium", size: 30.0)
    return name
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(nameComicsLabel)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    nameComicsLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
    nameComicsLabel.autoAlignAxis(toSuperviewAxis: .vertical)
  }
}
