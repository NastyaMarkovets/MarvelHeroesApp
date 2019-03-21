//
//  HeroComicsLayout.swift
//  
//
//  Created by LocalUser on 21/03/2019.
//

import UIKit

class HeroComicsLayout: UICollectionViewLayout {
  
  fileprivate var numberOfColumns = 2
  fileprivate var cellPadding: CGFloat = 6
  
  fileprivate var cache = [UICollectionViewLayoutAttributes]()
  
  fileprivate var contentHeight: CGFloat = 0
  
  fileprivate var contentWidth: CGFloat {
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
    guard cache.isEmpty == true, let collectionView = collectionView else {
      return
    }
    
    var xOffset = [CGFloat]()
    
    for column in 0 ..< numberOfColumns {
      let columnWidth = column == 1 ? (contentWidth / 3) * 2 : (contentWidth / 3)
      xOffset.append(CGFloat(column) * columnWidth)
    }
    
    var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
    var column = 0
    
    for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
      let indexPath = IndexPath(item: item, section: 0)
      let size = item % 3 == 0 ? (contentWidth / 3) * 2 : (contentWidth / 3)
      let frame = CGRect(x: xOffset[column], y: yOffset[column], width: size, height: size)
      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
      
      // 5
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = insetFrame
      cache.append(attributes)
      
      // 6
      contentHeight = max(contentHeight, frame.maxY)
      
      yOffset[column] = yOffset[column] + size
      
      column = item % 3 == 2 ? 0 : 1
    }
    
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
    var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
    
    // Loop through the cache and look for items in the rect
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

