//
//  FlowLayout.swift
//  AnimateBetweenCollectionLayouts
//
//  Created by Zheng on 6/24/21.
//

import UIKit

enum LayoutType {
    case list
    case strip
}

class FlowLayout: UICollectionViewFlowLayout {

    var layoutType: LayoutType
    var sizeForListItemAt: ((IndexPath) -> CGSize)? /// get size for list item
    var sizeForStripItemAt: ((IndexPath) -> CGSize)? /// get size for strip item
    
    var layoutAttributes = [UICollectionViewLayoutAttributes]() /// store the frame of each item
    var contentSize = CGSize.zero /// the scrollable content size of the collection view
    override var collectionViewContentSize: CGSize { return contentSize } /// pass scrollable content size back to the collection view
    
    override func prepare() { /// configure the cells' frames
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        let itemCount = collectionView.numberOfItems(inSection: 0) /// I only have 1 section
        
        if layoutType == .list {
            var y: CGFloat = 0 /// y position of each cell, start at 0
            for itemIndex in 0..<itemCount {
                let indexPath = IndexPath(item: itemIndex, section: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(
                    x: 0,
                    y: y,
                    width: sizeForListItemAt?(indexPath).width ?? 0,
                    height: sizeForListItemAt?(indexPath).height ?? 0
                )
                layoutAttributes.append(attributes)
                y += attributes.frame.height /// add height to y position, so next cell becomes offset
            }                           /// use first item's width
            contentSize = CGSize(width: sizeForStripItemAt?(IndexPath(item: 0, section: 0)).width ?? 0, height: y)
        } else {
            var x: CGFloat = 0 /// z position of each cell, start at 0
            for itemIndex in 0..<itemCount {
                let indexPath = IndexPath(item: itemIndex, section: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(
                    x: x,
                    y: 0,
                    width: sizeForStripItemAt?(indexPath).width ?? 0,
                    height: sizeForStripItemAt?(indexPath).height ?? 0
                )
                layoutAttributes.append(attributes)
                x += attributes.frame.width /// add width to z position, so next cell becomes offset
            }                              /// use first item's height
            contentSize = CGSize(width: x, height: sizeForStripItemAt?(IndexPath(item: 0, section: 0)).height ?? 0)
        }
    }
    
    /// pass attributes to the collection view flow layout
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.item]
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes.filter { rect.intersects($0.frame) }
    }

    /// initialize with a layout
    init(layoutType: LayoutType) {
        self.layoutType = layoutType
        super.init()
    }
    
    /// boilerplate code
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool { return true }
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }
}
