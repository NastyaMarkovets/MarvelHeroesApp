//
//  HeroTableViewCell.swift
//  MarvelHeroesApp
//
//  Created by Anastasia Markovets on 2/28/19.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import PureLayout

protocol FavoriteHeroDelegate: class {
  func setFavoriteHero(nameHero: String, heroId: Int)
}

class HeroTableViewCell: UITableViewCell {
  
  weak var delegate: FavoriteHeroDelegate?
  private let infoStackView = UIStackView()
  var heroId: Int?
  
  lazy var starButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "star"), for: .normal)
    button.autoSetDimensions(to: CGSize(width: 30.0, height: 30.0))
    button.contentHorizontalAlignment = .fill
    button.contentVerticalAlignment = .fill
    button.addTarget(self, action: #selector(clickFavorite), for: .touchUpInside)
    return button
  }()
  
  lazy var nameLabel: UILabel = {
    let name = UILabel()
    name.font = UIFont(name: "HelveticaNeue", size: 17.0)
    name.textColor = UIColor(red: 66.0/255.0, green: 143.0/255.0, blue: 222.0/255.0, alpha: 1.0)
    return name
  }()
  
  lazy var descLabel: UILabel = {
    let desc = UILabel()
    desc.numberOfLines = 4
    desc.font = UIFont(name: "HelveticaNeue", size: 14.0)
    return desc
  }()
  
  lazy var avatar: UIImageView = {
    let imageView = UIImageView()
    imageView.autoSetDimensions(to: CGSize(width: 100.0, height: 100.0))
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 50.0
    imageView.clipsToBounds = true
    return imageView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(starButton)
    contentView.addSubview(infoStackView)
    contentView.addSubview(avatar)
    
    contentView.bringSubviewToFront(starButton)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    starButton.autoPinEdge(.leading, to: .leading, of: avatar)
    starButton.autoPinEdge(.top, to: .top, of: avatar)
    
    avatar.autoAlignAxis(toSuperviewAxis: .horizontal)
    avatar.autoPinEdge(toSuperviewEdge: .left, withInset: 12.0)
    
    infoStackView.addArrangedSubview(nameLabel)
    infoStackView.addArrangedSubview(descLabel)
    infoStackView.axis = NSLayoutConstraint.Axis.vertical
    infoStackView.spacing = 6.0
    infoStackView.autoPinEdge(.left, to: .right, of: avatar, withOffset: 12.0)
    infoStackView.autoPinEdge(toSuperviewEdge: .right, withInset: 12.0)
    infoStackView.autoAlignAxis(toSuperviewAxis: .horizontal)
  }
  
  func configureCell(hero: Hero, favoriteId: Int) {
    selectionStyle = .none
    
    heroId = hero.heroId
    nameLabel.text = hero.nameHero
    descLabel.text = hero.descriptionHero
    
    if hero.heroId == favoriteId {
      starButton.setImage(UIImage(named: "starActive"), for: .normal)
    } else {
      starButton.setImage(UIImage(named: "star"), for: .normal)
    }
    if let path = hero.urlPhoto, let ext = hero.extensionForUrlPhoto {
      if let url = URL(string: path + "." + ext) {
        if url == URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg") {
          avatar.image = UIImage(named: "no_image")
          return
        }
        avatar.kf.indicatorType = .activity
        avatar.kf.setImage(with: url)
        
      } else {
        avatar.image = UIImage(named: "no_image")
      }
    }
  }
  
  @objc func clickFavorite() {
    if let heroId = heroId {
      let reference = Database.database().reference()
      guard let uid = Auth.auth().currentUser?.uid else { return }
      reference.child("users").child("\(String(describing: uid))").setValue(["heroId" : heroId])
      
      guard let nameHero = nameLabel.text else { return }
      delegate?.setFavoriteHero(nameHero: nameHero, heroId: heroId)
    }
  }
}
