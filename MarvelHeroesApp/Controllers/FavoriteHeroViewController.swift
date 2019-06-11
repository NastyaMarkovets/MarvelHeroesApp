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
import SnapKit
import BrightFutures

class FavoriteHeroViewController: UIViewController {
  
  private enum Dimensions {
    static let inset: CGFloat = 12
    static let insetTopToBottom: CGFloat = 6
    static let insetHorizontaly: CGFloat = 20
  }
  
  lazy var avatarFavorite: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.autoSetDimensions(to: CGSize(width: view.frame.width - Dimensions.insetHorizontaly * 2, height: view.frame.height / 2))
    imageView.layer.cornerRadius = 10
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
    
    let transition = PopAnimator()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    addSubviews()
    setupConstraints()
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
    avatarFavorite.isUserInteractionEnabled = true
    avatarFavorite.addGestureRecognizer(tapGestureRecognizer)
    
  }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let modalStyle = UIModalTransitionStyle.coverVertical
        let animationController = AnimationPictureViewController()
        animationController.transitioningDelegate = self
        animationController.photoHero = avatarFavorite.image

        animationController.modalTransitionStyle = modalStyle
        present(animationController, animated: true, completion: nil)
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
    avatarFavorite.snp.makeConstraints { image in
      image.top.equalTo(view).offset((tabBarController?.tabBar.frame.height ?? 0) + Dimensions.insetTopToBottom)
        image.centerX.equalTo(view)
    }
    
    nameFavoriteLabel.snp.makeConstraints { label in
      label.left.equalTo(view).offset(Dimensions.inset)
      label.right.equalTo(view).offset(Dimensions.inset)
      label.top.equalTo(avatarFavorite.snp.bottom).offset(Dimensions.insetTopToBottom)
    }
    
    descFavoriteTextView.snp.makeConstraints { textView in
      textView.left.equalTo(view).offset(Dimensions.inset)
      textView.right.equalTo(view).offset(Dimensions.inset)
      textView.bottom.equalTo(view).offset((tabBarController?.tabBar.frame.height ?? 0) + Dimensions.insetTopToBottom)
      textView.top.equalTo(nameFavoriteLabel.snp.bottom).offset(Dimensions.insetTopToBottom)
    }
  }
  
}

extension FavoriteHeroViewController: UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController, source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            
            guard let imageSuperview = avatarFavorite.superview else { return nil }
            
            transition.originFrame = imageSuperview.convert(avatarFavorite.frame, to: nil)
            transition.originFrame = CGRect(
                x: transition.originFrame.origin.x,
                y: transition.originFrame.origin.y,
                width: transition.originFrame.size.width,
                height: transition.originFrame.size.height
            )
            
            transition.presenting = true
            
            return transition
    }
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            transition.presenting = false
            return transition
    }
}
