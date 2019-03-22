//
//  HeroComicsLayout.swift
//  
//
//  Created by LocalUser on 21/03/2019.
//

import UIKit

class HeroComicsLayout: UICollectionViewLayout {
  
  private var numberOfColumns = 2
  private var cellPadding: CGFloat = 6
  
  private var cache = [UICollectionViewLayoutAttributes]()
  
  private var contentHeight: CGFloat = 0
  
  private var contentWidth: CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    let insets = collectionView.contentInset
    return collectionView.bounds.width - (insets.left + insets.right)
  }
  
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func prepare() {
    guard cache.isEmpty, let collectionView = collectionView else {
      return
    }
    
    var column = 0
    var xOffset = CGFloat()
    var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
    
    for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
      let indexPath = IndexPath(item: item, section: 0)
      var size: CGFloat = 0
      var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
      
      if item % 6 < 3 {
        let columnWidth = column == 0 ? (contentWidth / 3) : (contentWidth / 3) * 2
        xOffset = CGFloat(column) * columnWidth
        size = item % 6 == 0 ? (contentWidth / 3) * 2 : (contentWidth / 3)
        frame = CGRect(x: xOffset, y: yOffset[column], width: size, height: size)
        yOffset[column] = yOffset[column] + size
        column = item % 6 == 2 ? 0 : 1
      } else {
        let columnWidth = column == 0 ? (contentWidth / 3) * 2 : (contentWidth / 3)
        xOffset = CGFloat(column) * columnWidth
        size = item % 3 == 1 ? (contentWidth / 3) * 2 : (contentWidth / 3)
        frame = CGRect(x: xOffset, y: yOffset[column], width: size, height: size)
        yOffset[column] = yOffset[column] + size
        column = item % 3 != 0 ? 0 : 1
      }
      
      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = insetFrame
      cache.append(attributes)
      contentHeight = max(contentHeight, frame.maxY)
    }
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        visibleLayoutAttributes.append(attributes)
      }
    }
    return visibleLayoutAttributes
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }
  
}

