//
//  HeroModel.swift
//  MarvelHeroesApp
//
//  Created by Anastasia Markovets on 3/1/19.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import Foundation

class Hero: NSObject {
  var heroId: Int?
  var nameHero: String?
  var descriptionHero: String?
  var urlPhoto: String?
  var extensionForUrlPhoto: String? 
  var photoHero: Data? = nil
}
