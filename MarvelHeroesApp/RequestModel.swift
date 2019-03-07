//
//  RequestModel.swift
//  MarvelHeroesApp
//
//  Created by Anastasia Markovets on 3/1/19.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import UIKit
import Alamofire

class RequestModel: NSObject {
    
    let url = "https://gateway.marvel.com/v1/public"
    let header = [
        "Content-Type" : "application/json; charset=utf-8"
    ]
    
    let apiModel = ApiModel()
    
    func getCharacters(page: Int, success: @escaping ([Hero]) -> (), failure: @escaping (String) -> ()) {
        let limit = 7
        let offset = page * limit
        let queryParams = ["offset": String(offset), "limit": String(limit)].queryString!
        let urlCharacters = url + "/characters?" + queryParams + self.apiModel.getAuth()

        Alamofire.request(urlCharacters, method: .get, encoding: JSONEncoding.default, headers: header).validate().responseJSON { (res) in
            if res.result.isSuccess {
                if let value = res.result.value as? [String : Any] {
                    if let data = value["data"] as? [String : Any] {
                        if let results = data["results"] as? [[String : Any]] {
                            var heroes = [Hero]()
                            for i in 0 ..< limit {
                                let hero = Hero()
                                guard let name = results[i]["name"] as? String else { return }
                                guard let desc = results[i]["description"] as? String else { return }
                                if let thumbnail = results[i]["thumbnail"] as? [String : Any] {
                                    guard let img = thumbnail["path"] as? String else { return }
                                    guard let ext = thumbnail["extension"] as? String else { return }
                                    
                                    hero.nameHero = name
                                    hero.descriptionHero = desc
                                    hero.urlPhoto = img
                                    hero.extensionPhoto = ext
                                }
                                heroes.append(hero)
                            }
                            success(heroes)
                        }
                    }
                } else {
                    failure("No data was found.")
                }
            } else {
                failure("Request bad.")
            }
        }
    }
}
