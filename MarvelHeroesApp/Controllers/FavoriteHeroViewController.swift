//
//  FavoriteHeroViewController.swift
//  MarvelHeroesApp
//
//  Created by Anastasia Markovets on 2/28/19.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import UIKit
import RealmSwift
import PureLayout

class FavoriteHeroViewController: UIViewController {
    
    
    lazy var avatarFavorite: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "no_avatar")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.autoSetDimensions(to: CGSize(width: self.view.frame.width, height: self.view.frame.height / 2))
        return imageView
    }()
    
    lazy var nameFavoriteLabel: UILabel = {
        let name = UILabel()
        name.text = ""
        name.textAlignment = .center
        name.textColor = UIColor(red: 66.0/255.0, green: 143.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        name.font = UIFont(name: "HelveticaNeue-Medium", size: 30.0)
        return name
    }()
    
    lazy var descFavoriteTextView: UITextView = {
        let desc = UITextView()
        desc.text = ""
        desc.font = UIFont(name: "HelveticaNeue", size: 17.0)
        desc.isSelectable = false
        return desc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        self.addSubviews()
        self.setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let realm = try! Realm()
        
        let favoriteHero = realm.objects(Hero.self)
        if favoriteHero.count != 0 {
            self.nameFavoriteLabel.text = favoriteHero[0].nameHero
            self.descFavoriteTextView.text = favoriteHero[0].descriptionHero
            self.avatarFavorite.image = UIImage(data: favoriteHero[0].photoHero!)
            
            self.nameFavoriteLabel.textColor = UIColor(red: 66.0/255.0, green: 143.0/255.0, blue: 222.0/255.0, alpha: 1.0)
            self.nameFavoriteLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 30.0)
        } else {
            self.nameFavoriteLabel.text = "No favorite character"
            self.nameFavoriteLabel.textColor = .lightGray
            self.nameFavoriteLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)

        }
      
    }
    
    func addSubviews() {
        self.view.addSubview(nameFavoriteLabel)
        self.view.addSubview(avatarFavorite)
        self.view.addSubview(descFavoriteTextView)
    }
    
    func setupConstraints() {
        avatarFavorite.autoPinEdge(toSuperviewEdge: .top, withInset: UIApplication.shared.statusBarFrame.height)
        
        nameFavoriteLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 12.0)
        nameFavoriteLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 12.0)
        nameFavoriteLabel.autoPinEdge(.top, to: .bottom, of: avatarFavorite, withOffset: 6.0)

        descFavoriteTextView.autoPinEdge(toSuperviewEdge: .left, withInset: 12.0)
        descFavoriteTextView.autoPinEdge(toSuperviewEdge: .right, withInset: 12.0)
        descFavoriteTextView.autoPinEdge(toSuperviewEdge: .bottom, withInset: self.tabBarController!.tabBar.frame.height + 6.0)
        descFavoriteTextView.autoPinEdge(.top, to: .bottom, of: nameFavoriteLabel, withOffset: 6.0)
    }

}
