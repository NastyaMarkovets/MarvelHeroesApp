//
//  HeroComicsViewController.swift
//  
//
//  Created by LocalUser on 21/03/2019.
//

import UIKit

class HeroComicsViewController: UIViewController {
  
  let heroComicsLayout = HeroComicsLayout()
  private var currentPage = 0
  var heroId: Int?
  var comicsCollection: [Comics] = []
  
  private enum Dimensions {
    static let inset: CGFloat = 0
  }
  
  lazy var comicsCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: heroComicsLayout)
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
    loadComics()
  }
  
  private func addSubviews() {
    view.addSubview(comicsCollectionView)
  }
  
  private func setupConstraints() {
    comicsCollectionView.autoPinEdge(toSuperviewEdge: .top, withInset: UIApplication.shared.statusBarFrame.height)
    comicsCollectionView.autoPinEdge(toSuperviewEdge: .bottom, withInset: tabBarController?.tabBar.frame.height ?? Dimensions.inset)
    comicsCollectionView.autoPinEdge(toSuperviewEdge: .right, withInset: Dimensions.inset)
    comicsCollectionView.autoPinEdge(toSuperviewEdge: .left, withInset: Dimensions.inset)
  }

  private func loadComics() {
    FactoryManager.shared.marvelAPIManager.getComics(page: currentPage, heroId: heroId ?? 0, success: { [weak self] (success) in
      guard let self = self else {
        return
      }
      self.comicsCollection += success
      self.comicsCollectionView.reloadData()
    }) { (failure) in
      print(failure)
    }
  }
  
}

// MARK: - UICollectionViewDelegate and UICollectionViewDataSource
extension HeroComicsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return comicsCollection.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroComicsCollectionViewCell.reuseIdentifier, for: indexPath as IndexPath) as? HeroComicsCollectionViewCell else {
      return UICollectionViewCell()
    }
    if let path = comicsCollection[indexPath.row].urlPhotoComics, let ext = comicsCollection[indexPath.row].extensionForUrlPhoto {
      if let url = URL(string: path + "." + ext) {
        cell.imageComics.kf.indicatorType = .activity
        cell.imageComics.kf.setImage(with: url)
      } else {
        cell.imageComics.image = UIImage.noImage()
      }
    }
    cell.nameComicsLabel.text = comicsCollection[indexPath.row].nameComics
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if ((indexPath.row + 1) % 7 == 0) && (indexPath.row + 1 == (comicsCollection.count)) {
      currentPage += 1
      loadComics()
    }
  }
}
