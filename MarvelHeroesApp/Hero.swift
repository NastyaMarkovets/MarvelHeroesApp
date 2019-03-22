//
//  HeroModel.swift
//  MarvelHeroesApp
//
//  Created by Anastasia Markovets on 3/1/19.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import Foundation
import RealmSwift

class Hero: Object {
  @objc dynamic var heroId = 0
  @objc dynamic var nameHero = ""
  @objc dynamic var descriptionHero = ""
  @objc dynamic var urlPhoto: String? = ""
  @objc dynamic var extensionForUrlPhoto: String? = ""
  @objc dynamic var photoHero: Data? = nil
}
