//
//  RequestModel.swift
//  MarvelHeroesApp
//
//  Created by Anastasia Markovets on 3/1/19.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import Foundation
import Alamofire
import Firebase
import FirebaseAuth

class RequestModel: NSObject {
  
  let apiModel = ApiModel()
  
  private enum UrlComponents {
    static let url = "https://gateway.marvel.com/v1/public"
    static let header = ["Content-Type" : "application/json; charset=utf-8"]
    static let limit = 7
  }
  
  func getCharacters(page: Int, success: @escaping ([Hero]) -> (), failure: @escaping (String) -> Void) {
    let offset = page * UrlComponents.limit
    let queryParams = ["offset": String(offset), "limit": String(UrlComponents.limit)].queryString
    let urlCharacters = UrlComponents.url + "/characters?" + queryParams + apiModel.getAuth()
    
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
  
  func getComics(page: Int, heroId: Int, success: @escaping ([Comics]) -> (), failure: @escaping (String) -> Void) {
    let offset = page * UrlComponents.limit
    let queryParams = ["offset": String(offset), "limit": UrlComponents.limit].queryString 
    let urlCharacters = UrlComponents.url + "/characters" + "/\(heroId)" + "/comics?" + queryParams + apiModel.getAuth()
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
  
  func createUser(email: String, password: String, success: @escaping (String) -> (), failure: @escaping (String) -> Void) {
    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
      if error == nil {
        success("You have successfully signed up")
      } else {
        guard let acceptedError = error?.localizedDescription else { return }
        failure("Sorry, \(String(describing: acceptedError))")
        
      }
    }
  }
  
  func signInAccount(email: String, password: String, success: @escaping (String) -> (), failure: @escaping (String) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
      if error == nil {
        success("You have successfully signed in")
      } else {
        guard let acceptedError = error?.localizedDescription else { return }
        failure("Sorry, \(String(describing: acceptedError))")
        
      }
    }
  }
  
}
