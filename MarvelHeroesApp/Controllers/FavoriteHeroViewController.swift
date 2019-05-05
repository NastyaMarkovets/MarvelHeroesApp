//
//  FavoriteHeroViewController.swift
//  MarvelHeroesApp
//
//  Created by Anastasia Markovets on 2/28/19.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import PureLayout
import BrightFutures

class FavoriteHeroViewController: UIViewController {
  
  private enum Dimensions {
    static let inset: CGFloat = 12
    static let insetTopToBottom: CGFloat = 6
  }
  
  lazy var avatarFavorite: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.autoSetDimensions(to: CGSize(width: view.frame.width, height: view.frame.height / 2))
    return imageView
  }()
  
  lazy var nameFavoriteLabel: UILabel = {
    let name = UILabel()
    name.text = ""
    name.textAlignment = .center
    name.textColor = UIColor.customGray()
    name.font = UIFont.fontHelveticaMedium(size: 30.0)
    return name
  }()
  
  lazy var descFavoriteTextView: UITextView = {
    let desc = UITextView()
    desc.text = ""
    desc.font = UIFont.fontHelveticaRegular(size: 17.0)
    desc.isSelectable = false
    return desc
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    addSubviews()
    setupConstraints()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    FactoryManager.shared.firebaseManager.fetchHero().onSuccess { [weak self] heroId in
      FactoryManager.shared.marvelAPIManager.getCharacter(heroId: heroId).onSuccess { [weak self] hero in
        guard let self = self else {
          return
        }
        self.nameFavoriteLabel.text = hero.nameHero
        self.descFavoriteTextView.text = hero.descriptionHero
        self.nameFavoriteLabel.textColor = UIColor.customBlue()
        
        if let path = hero.urlPhoto, let ext = hero.extensionForUrlPhoto {
          if let url = URL(string: path + "." + ext) {
            if url == URL(string: Constants.urlNoImage) {
              self.avatarFavorite.image = UIImage.noImage()
              return
            }
            self.avatarFavorite.kf.indicatorType = .activity
            self.avatarFavorite.kf.setImage(with: url)
          } else {
            self.avatarFavorite.image = UIImage.noImage()
          }
        }
      }.onFailure { error in
        print(error.localizedDescription)
      }
    }
  }
  
  private func addSubviews() {
    view.addSubview(nameFavoriteLabel)
    view.addSubview(avatarFavorite)
    view.addSubview(descFavoriteTextView)
  }
  
  private func setupConstraints() {
    avatarFavorite.autoPinEdge(toSuperviewEdge: .top, withInset: UIApplication.shared.statusBarFrame.height)
    
    nameFavoriteLabel.autoPinEdge(toSuperviewEdge: .left, withInset: Dimensions.inset)
    nameFavoriteLabel.autoPinEdge(toSuperviewEdge: .right, withInset: Dimensions.inset)
    nameFavoriteLabel.autoPinEdge(.top, to: .bottom, of: avatarFavorite, withOffset: Dimensions.insetTopToBottom)
    
    descFavoriteTextView.autoPinEdge(toSuperviewEdge: .left, withInset: Dimensions.inset)
    descFavoriteTextView.autoPinEdge(toSuperviewEdge: .right, withInset: Dimensions.inset)
    descFavoriteTextView.autoPinEdge(toSuperviewEdge: .bottom, withInset: (tabBarController?.tabBar.frame.height ?? 0) + Dimensions.insetTopToBottom)
    descFavoriteTextView.autoPinEdge(.top, to: .bottom, of: nameFavoriteLabel, withOffset: Dimensions.insetTopToBottom)
  }
  
}
