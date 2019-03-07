//
//  HeroesViewController.swift
//  MarvelHeroesApp
//
//  Created by Anastasia Markovets on 2/28/19.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import UIKit
import PureLayout
import RealmSwift
import Kingfisher

class HeroesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FavoriteHeroDelegate {
    
    let realm = try! Realm()
    private let cellId = "cellId"
    var heroes = [Hero]()
    var currentPage = 0
    let requestModel = RequestModel()
    
    var favoriteHero = "" {
        didSet {
            self.heroesTableView.reloadData()
        }
    }
    
    lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        indicator.backgroundColor = UIColor.white
        indicator.hidesWhenStopped = true
        indicator.style = .gray
        return indicator
    }()
    
    lazy var heroesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HeroTableViewCell.self, forCellReuseIdentifier: self.cellId)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.indicator.startAnimating()

        self.addSubviews()
        self.setupConstraints()
        self.loadCharacters()
        
        if realm.objects(Hero.self).count != 0 {
            favoriteHero = realm.objects(Hero.self)[0].nameHero
        }
    }
    
    func addSubviews() {
        self.view.addSubview(heroesTableView)
        self.view.addSubview(indicator)

    }
    
    func setupConstraints() {
        heroesTableView.autoPinEdge(toSuperviewEdge: .top, withInset: UIApplication.shared.statusBarFrame.height)
        heroesTableView.autoPinEdge(toSuperviewEdge: .bottom, withInset: self.tabBarController!.tabBar.frame.height)
        heroesTableView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        heroesTableView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
    }
    
    func loadCharacters() {
        self.requestModel.getCharacters(page: self.currentPage, success: { [weak self] (success) in
            self?.heroes += success
            self?.heroesTableView.reloadData()
            UIView.animate(withDuration: 0.5, animations: {
                self?.indicator.alpha = 0
            }, completion: { (bool) in
                self?.indicator.stopAnimating()
            })
        }) { (failure) in
            self.indicator.stopAnimating()
        }
    }

    func setFavoriteHero(name: String) {
        self.favoriteHero = name
        let alert = UIAlertController(title: "Now, \(name) is your favorite character", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.heroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! HeroTableViewCell
        cell.delegate = self
        cell.configureCell(hero: heroes[indexPath.row], favoriteName: self.favoriteHero)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if ((indexPath.row + 1) % 7 == 0) && (indexPath.row + 1 == self.heroes.count) {
            self.currentPage += 1
            self.loadCharacters()
        }
    }

}
