//
//  RequestModel.swift
//  MarvelHeroesApp
//
//  Created by Anastasia Markovets on 3/1/19.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import Foundation
import Alamofire

class RequestModel: NSObject {
  
  let apiModel = ApiModel()
  
  private enum UrlComponents {
    static let url = "https://gateway.marvel.com/v1/public"
    static let header = ["Content-Type" : "application/json; charset=utf-8"]
    static let limit = 7
  }
  
  func gettingCharacters(page: Int, success: @escaping ([Hero]) -> (), failure: @escaping (String) -> ()) {
    let offset = page * UrlComponents.limit
    let queryParams = ["offset": String(offset), "limit": String(UrlComponents.limit)].queryString!
    let urlCharacters = UrlComponents.url + "/characters?" + queryParams + apiModel.gettingAuth()
    
    Alamofire.request(urlCharacters, method: .get, encoding: JSONEncoding.default, headers: UrlComponents.header).validate().responseJSON { response in
      if response.result.isSuccess {
         if let value = response.result.value as? [String : Any] {
          guard let data = value["data"] as? [String : Any]  else {
            failure("Request bad.")
            return
          }
          guard let results = data["results"] as? [[String : Any]] else {
            failure("No data was found.")
            return
          }
          var heroes: [Hero] = []
          for i in 0 ..< UrlComponents.limit {
            let hero = Hero()
            guard
              let name = results[i]["name"] as? String,
              let desc = results[i]["description"] as? String
              else { return }
            
            if let thumbnail = results[i]["thumbnail"] as? [String : Any] {
              guard
                let img = thumbnail["path"] as? String,
                let ext = thumbnail["extension"] as? String
                else { return }
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
  
}
