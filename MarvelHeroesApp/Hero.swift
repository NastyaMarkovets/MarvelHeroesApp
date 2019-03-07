//
//  HeroModel.swift
//  MarvelHeroesApp
//
//  Created by Anastasia Markovets on 3/1/19.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import UIKit
import RealmSwift

class Hero: Object {
    @objc dynamic var nameHero: String = ""
    @objc dynamic var descriptionHero: String = ""
    @objc dynamic var urlPhoto: String? = ""
    @objc dynamic var extensionPhoto: String? = ""
    @objc dynamic var photoHero: Data? = nil
}
