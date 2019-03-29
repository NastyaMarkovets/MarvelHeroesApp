//
//  MarvelAPIManager.swift
//  MarvelHeroesApp
//
//  Created by LocalUser on 29/03/2019.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import Foundation
import Alamofire

class MarvelAPIManager: NSObject {
  
  private enum UrlComponents {
    static let url = "https://gateway.marvel.com/v1/public"
    static let header = ["Content-Type" : "application/json; charset=utf-8"]
    static let limit = 7
    static let timestamp = Int(Date().timeIntervalSince1970)
  }
  
  private func getAuth() -> String {
    var hash = String()
    hash = "\(UrlComponents.timestamp)\(Constants.marvelApiPrivateKey)\(Constants.marvelApiPublicKey)".md5()
    return ["ts": UrlComponents.timestamp, "apikey": Constants.marvelApiPublicKey, "hash": hash].queryString
  }
  
  func getCharacters(page: Int, success: @escaping ([Hero]) -> (), failure: @escaping (String) -> Void) {
    let offset = page * UrlComponents.limit
    let queryParams = ["offset": String(offset), "limit": String(UrlComponents.limit)].queryString
    let urlCharacters = UrlComponents.url + "/characters?" + queryParams + getAuth()
    
    Alamofire.request(urlCharacters, method: .get, encoding: JSONEncoding.default, headers: UrlComponents.header).validate().responseJSON { response in
      if response.result.isSuccess {
        if let value = response.result.value as? [String : Any] {
          guard let data = value["data"] as? [String : Any]  else {
            failure("Problem with request.")
            return
          }
          guard let results = data["results"] as? [[String : Any]] else {
            failure("No data was found.")
            return
          }
          var heroes: [Hero] = []
          for index in 0 ..< UrlComponents.limit {
            let hero = Hero()
            guard
              let id = results[index]["id"] as? Int,
              let name = results[index]["name"] as? String,
              let desc = results[index]["description"] as? String
              else { return }
            
            if let thumbnail = results[index]["thumbnail"] as? [String : Any] {
              guard
                let img = thumbnail["path"] as? String,
                let ext = thumbnail["extension"] as? String
                else { return }
              hero.heroId = id
              hero.nameHero = name
              hero.descriptionHero = desc
              hero.urlPhoto = img
              hero.extensionForUrlPhoto = ext
            }
            heroes.append(hero)
          }
          success(heroes)
        }
      }
    }
  }
  
  func getCharacter(heroId: Int, success: @escaping (Hero) -> (), failure: @escaping (String) -> Void) {
    let urlCharacters = UrlComponents.url + "/characters" + "/\(heroId)?" + getAuth()
    Alamofire.request(urlCharacters, method: .get, encoding: JSONEncoding.default, headers: UrlComponents.header).validate().responseJSON { response in
      if response.result.isSuccess {
        if let value = response.result.value as? [String : Any] {
          guard let data = value["data"] as? [String : Any]  else {
            failure("Problem with request.")
            return
          }
          guard let results = data["results"] as? [[String : Any]] else {
            failure("No data was found.")
            return
          }
          let hero = Hero()
          guard
            let id = results[0]["id"] as? Int,
            let name = results[0]["name"] as? String,
            let desc = results[0]["description"] as? String
            else { return }
          
          if let thumbnail = results[0]["thumbnail"] as? [String : Any] {
            guard
              let img = thumbnail["path"] as? String,
              let ext = thumbnail["extension"] as? String
              else { return }
            hero.heroId = id
            hero.nameHero = name
            hero.descriptionHero = desc
            hero.urlPhoto = img
            hero.extensionForUrlPhoto = ext
          }
          success(hero)
        }
      } else {
        failure("Problem with request.")
      }
    }
  }
  
  func getComics(page: Int, heroId: Int, success: @escaping ([Comics]) -> (), failure: @escaping (String) -> Void) {
    let offset = page * UrlComponents.limit
    let queryParams = ["offset": String(offset), "limit": UrlComponents.limit].queryString
    let urlCharacters = UrlComponents.url + "/characters" + "/\(heroId)" + "/comics?" + queryParams + getAuth()
    Alamofire.request(urlCharacters, method: .get, encoding: JSONEncoding.default, headers: UrlComponents.header).validate().responseJSON { response in
      if response.result.isSuccess {
        if let value = response.result.value as? [String : Any] {
          guard let data = value["data"] as? [String : Any]  else {
            failure("Problem with request")
            return
          }
          guard let results = data["results"] as? [[String : Any]] else {
            failure("No data was found.")
            return
          }
          var comicsCollection: [Comics] = []
          for index in 0 ..< results.count {
            let comics = Comics()
            guard let id = results[index]["id"] as? Int, let title = results[index]["title"] as? String else { return }
            
            if let thumbnail = results[index]["thumbnail"] as? [String : Any] {
              guard let img = thumbnail["path"] as? String, let ext = thumbnail["extension"] as? String else { return }
              comics.idComics = id
              comics.nameComics = title
              comics.urlPhotoComics = img
              comics.extensionForUrlPhoto = ext
            }
            comicsCollection.append(comics)
          }
          success(comicsCollection)
        }
      }
    }
  }
}
