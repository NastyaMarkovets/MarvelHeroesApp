//
//  HeroTableViewCell.swift
//  MarvelHeroesApp
//
//  Created by Anastasia Markovets on 2/28/19.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import UIKit
import RealmSwift
import PureLayout

protocol FavoriteHeroDelegate: class {
    func setFavoriteHero(name: String)
}

class HeroTableViewCell: UITableViewCell {
    
    let realm = try! Realm()
    weak var delegate: FavoriteHeroDelegate?
    let infoStackView = UIStackView()

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
        
        self.contentView.addSubview(starButton)
        self.contentView.addSubview(infoStackView)
        self.contentView.addSubview(avatar)
        
        self.contentView.bringSubviewToFront(starButton)
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
    
    func configureCell(hero: Hero, favoriteName: String) {
        self.selectionStyle = .none
        
        self.nameLabel.text = hero.nameHero
        self.descLabel.text = hero.descriptionHero
        
        if hero.nameHero == favoriteName {
            self.starButton.setImage(UIImage(named: "starActive"), for: .normal)
        } else {
            self.starButton.setImage(UIImage(named: "star"), for: .normal)
        }
        if let path = hero.urlPhoto, let ext = hero.extensionPhoto {
            if let url = URL(string: path + "." + ext) {
                if url == URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg") {
                    self.avatar.image = UIImage(named: "no_image")
                    return
                }
                self.avatar.kf.indicatorType = .activity
                self.avatar.kf.setImage(with: url)
                
            } else {
                self.avatar.image = UIImage(named: "no_image")
            }
        }

    }
    
    @objc func clickFavorite() {
        let hero = Hero()
        hero.nameHero = self.nameLabel.text!
        hero.descriptionHero = self.descLabel.text!
        hero.photoHero = self.avatar.image!.pngData()

        try! realm.write {
            if realm.objects(Hero.self).count > 0 {
                realm.deleteAll()
            } 
            realm.add(hero)
        }
        
        self.delegate?.setFavoriteHero(name: hero.nameHero)

    }

}
