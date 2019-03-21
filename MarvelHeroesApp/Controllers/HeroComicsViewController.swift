//
//  HeroComicsViewController.swift
//  
//
//  Created by LocalUser on 21/03/2019.
//

import UIKit

class HeroComicsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
  let heroComicsLayout = HeroComicsLayout()
  
  lazy var comicsCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: heroComicsLayout)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .white
    collectionView.register(HeroComicsCollectionViewCell.self, forCellWithReuseIdentifier: HeroComicsCollectionViewCell.reuseIdentifier)
    return collectionView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    addSubviews()
  }
  
  private func addSubviews() {
    view.addSubview(comicsCollectionView)
  }
  
  private func setupConstraints() {
    comicsCollectionView.autoPinEdge(toSuperviewEdge: .top, withInset: UIApplication.shared.statusBarFrame.height)
    comicsCollectionView.autoPinEdge(toSuperviewEdge: .bottom, withInset: tabBarController?.tabBar.frame.height ?? 0)
    comicsCollectionView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
    comicsCollectionView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 30
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroComicsCollectionViewCell.reuseIdentifier, for: indexPath as IndexPath) as? HeroComicsCollectionViewCell else {
      return UICollectionViewCell()
    }
    cell.imageComics.image = UIImage(named: "no_image")
    cell.nameComicsLabel.text = "Comics"
    return cell
  }

}
