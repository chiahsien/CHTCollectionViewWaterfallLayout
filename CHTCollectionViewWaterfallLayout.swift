//
//  CHTCollectionViewWaterfallLayout.swift
//  PinterestSwift
//
//  Created by Nicholas Tau on 6/30/14.
//  Copyright (c) 2014 Nicholas Tau. All rights reserved.
//

import Foundation
import UIKit
fileprivate func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


@objc public protocol CHTCollectionViewDelegateWaterfallLayout: UICollectionViewDelegate {

    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize

    @objc optional func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                        heightForHeaderInSection section: Int) -> CGFloat

    @objc optional func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                        heightForFooterInSection section: Int) -> CGFloat

    @objc optional func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                        insetForSectionAtIndex section: Int) -> UIEdgeInsets

    @objc optional func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat

    @objc optional func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                        columnCountForSection section: Int) -> Int
}

public enum CHTCollectionViewWaterfallLayoutItemRenderDirection: Int {
    case chtCollectionViewWaterfallLayoutItemRenderDirectionShortestFirst
    case chtCollectionViewWaterfallLayoutItemRenderDirectionLeftToRight
    case chtCollectionViewWaterfallLayoutItemRenderDirectionRightToLeft
}

public  let CHTCollectionElementKindSectionHeader = "CHTCollectionElementKindSectionHeader"
public  let CHTCollectionElementKindSectionFooter = "CHTCollectionElementKindSectionFooter"
public class CHTCollectionViewWaterfallLayout: UICollectionViewLayout {
    public var columnCount: Int {
        didSet {
            invalidateLayout()
        }}

    public var minimumColumnSpacing: CGFloat {
        didSet {
            invalidateLayout()
        }}

    public var minimumInteritemSpacing: CGFloat {
        didSet {
            invalidateLayout()
        }}

    public var headerHeight: CGFloat {
        didSet {
            invalidateLayout()
        }}

    public var footerHeight: CGFloat {
        didSet {
            invalidateLayout()
        }}

    public var sectionInset: UIEdgeInsets {
        didSet {
            invalidateLayout()
        }}


    public var itemRenderDirection: CHTCollectionViewWaterfallLayoutItemRenderDirection {
        didSet {
            invalidateLayout()
        }
    }


    //    private property and method above.
    public weak var delegate: CHTCollectionViewDelegateWaterfallLayout? {
        get {
            return self.collectionView!.delegate as? CHTCollectionViewDelegateWaterfallLayout
        }
    }
    public var columnHeights: [[CGFloat]]
    public var sectionItemAttributes: [[UICollectionViewLayoutAttributes]]
    public var allItemAttributes: [UICollectionViewLayoutAttributes]
    public var headersAttributes: [Int: UICollectionViewLayoutAttributes]
    public var footersAttributes: [Int: UICollectionViewLayoutAttributes]
    public var unionRects: [NSValue]
    public let unionSize = 20

    override public init() {
        self.headerHeight = 0.0
        self.footerHeight = 0.0
        self.columnCount = 2
        self.minimumInteritemSpacing = 10
        self.minimumColumnSpacing = 10
        self.sectionInset = UIEdgeInsets.zero
        self.itemRenderDirection =
            CHTCollectionViewWaterfallLayoutItemRenderDirection.chtCollectionViewWaterfallLayoutItemRenderDirectionShortestFirst

        headersAttributes = [:]
        footersAttributes = [:]
        unionRects = []
        columnHeights = []
        allItemAttributes = []
        sectionItemAttributes = []

        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func columnCountForSection (_ section: Int) -> Int {
        if let columnCount = self.delegate?.collectionView?(self.collectionView!, layout: self, columnCountForSection: section) {
            return columnCount
        } else {
            return self.columnCount
        }
    }

    public func itemWidthInSectionAtIndex (_ section: Int) -> CGFloat {
        var insets: UIEdgeInsets
        if let sectionInsets = self.delegate?.collectionView?(self.collectionView!, layout: self, insetForSectionAtIndex: section) {
            insets = sectionInsets
        } else {
            insets = self.sectionInset
        }
        let width: CGFloat = self.collectionView!.bounds.size.width - insets.left - insets.right
        let columnCount = self.columnCountForSection(section)
        let spaceColumCount: CGFloat = CGFloat(columnCount - 1)
        return floor((width - (spaceColumCount * self.minimumColumnSpacing)) / CGFloat(columnCount))
    }

    override public func prepare() {
        super.prepare()

        let numberOfSections = self.collectionView!.numberOfSections
        if numberOfSections == 0 {
            return
        }

        self.headersAttributes = [:]
        self.footersAttributes = [:]
        self.unionRects = []
        self.columnHeights = []
        self.allItemAttributes = []
        self.sectionItemAttributes = []

        for section in 0 ..< numberOfSections {
            let columnCount = self.columnCountForSection(section)
            var sectionColumnHeights: [CGFloat] = []
            for idx in 0 ..< columnCount {
                sectionColumnHeights.append(CGFloat(idx))
            }
            self.columnHeights.append(sectionColumnHeights)
        }

        var top: CGFloat = 0.0
        var attributes = UICollectionViewLayoutAttributes()

        for section in 0 ..< numberOfSections {
            /*
             * 1. Get section-specific metrics (minimumInteritemSpacing, sectionInset)
             */
            var minimumInteritemSpacing: CGFloat
            if let miniumSpaceing = self.delegate?.collectionView?(self.collectionView!, layout: self, minimumInteritemSpacingForSectionAtIndex: section) {
                minimumInteritemSpacing = miniumSpaceing
            } else {
                minimumInteritemSpacing = self.minimumColumnSpacing
            }

            var sectionInsets: UIEdgeInsets
            if let insets = self.delegate?.collectionView?(self.collectionView!, layout: self, insetForSectionAtIndex: section) {
                sectionInsets = insets
            } else {
                sectionInsets = self.sectionInset
            }

            let width = self.collectionView!.bounds.size.width - sectionInsets.left - sectionInsets.right
            let columnCount = self.columnCountForSection(section)
            let spaceColumCount = CGFloat(columnCount - 1)
            let itemWidth = floor((width - (spaceColumCount * self.minimumColumnSpacing)) / CGFloat(columnCount))

            /*
             * 2. Section header
             */
            var heightHeader: CGFloat
            if let height = self.delegate?.collectionView?(self.collectionView!, layout: self, heightForHeaderInSection: section) {
                heightHeader = height
            } else {
                heightHeader = self.headerHeight
            }

            if heightHeader > 0 {
                attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: CHTCollectionElementKindSectionHeader, with: IndexPath(row: 0, section: section))
                attributes.frame = CGRect(x: 0, y: top, width: self.collectionView!.bounds.size.width, height: heightHeader)
                self.headersAttributes[section] = attributes
                self.allItemAttributes.append(attributes)

                top = attributes.frame.maxY
            }
            top += sectionInsets.top
            for idx in 0 ..< columnCount {
                self.columnHeights[section][idx]=top
            }

            /*
             * 3. Section items
             */
            let itemCount = self.collectionView!.numberOfItems(inSection: section)
            var itemAttributes: [UICollectionViewLayoutAttributes] = []

            // Item will be put into shortest column.
            for idx in 0 ..< itemCount {
                let indexPath = IndexPath(item: idx, section: section)

                let columnIndex = self.nextColumnIndexForItem(idx, section: section)
                let xOffset = sectionInsets.left + (itemWidth + self.minimumColumnSpacing) * CGFloat(columnIndex)

                let yOffset = ((self.columnHeights[section] as AnyObject).object (at: columnIndex) as AnyObject).doubleValue
                let itemSize = self.delegate?.collectionView(self.collectionView!, layout: self, sizeForItemAtIndexPath: indexPath)
                var itemHeight: CGFloat = 0.0
                if itemSize?.height > 0 && itemSize?.width > 0 {
                    itemHeight = floor(itemSize!.height * itemWidth / itemSize!.width)
                }

                attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: CGFloat(yOffset!), width: itemWidth, height: itemHeight)
                itemAttributes.append(attributes)
                self.allItemAttributes.append(attributes)

                self.columnHeights[section][columnIndex] = attributes.frame.maxY + minimumInteritemSpacing

            }
            self.sectionItemAttributes.append(itemAttributes)

            /*
             * 4. Section footer
             */
            var footerHeight: CGFloat = 0.0
            let columnIndex  = self.longestColumnIndexInSection(section)
            top = self.columnHeights[section][columnIndex] - minimumInteritemSpacing + sectionInsets.bottom

            if let height = self.delegate?.collectionView?(self.collectionView!, layout: self, heightForFooterInSection: section) {
                footerHeight = height
            } else {
                footerHeight = self.footerHeight
            }

            if footerHeight > 0 {
                attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: CHTCollectionElementKindSectionFooter, with: IndexPath(item: 0, section: section))
                attributes.frame = CGRect(x: 0, y: top, width: self.collectionView!.bounds.size.width, height: footerHeight)
                self.footersAttributes[section] = attributes
                self.allItemAttributes.append(attributes)
                top = attributes.frame.maxY
            }

            for idx in 0 ..< columnCount {
                self.columnHeights[section][idx] = top
            }
        }

        var idx = 0
        let itemCounts = self.allItemAttributes.count
        while idx < itemCounts {
            let rect1 = self.allItemAttributes[idx].frame
            idx = min(idx + unionSize, itemCounts) - 1
            let rect2 = self.allItemAttributes[idx].frame
            self.unionRects.append(NSValue(cgRect:rect1.union(rect2)))
            idx += 1
        }
    }

    override public var collectionViewContentSize: CGSize {
        let numberOfSections = self.collectionView!.numberOfSections
        if numberOfSections == 0 {
            return CGSize.zero
        }

        var contentSize = self.collectionView!.bounds.size as CGSize

        if columnHeights.count > 0 {
            if let height = self.columnHeights[columnHeights.count - 1].first {
                contentSize.height = height
                return contentSize
            }
        }
        return CGSize.zero
    }

    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if (indexPath as NSIndexPath).section >= self.sectionItemAttributes.count {
            return nil
        }
        let list = self.sectionItemAttributes[indexPath.section]
        if (indexPath as NSIndexPath).item >= list.count {
            return nil
        }
        return list[indexPath.item]
    }

    override public func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        var attribute: UICollectionViewLayoutAttributes?
        if elementKind == CHTCollectionElementKindSectionHeader {
            attribute = self.headersAttributes[indexPath.section]
        } else if elementKind == CHTCollectionElementKindSectionFooter {
            attribute = self.footersAttributes[indexPath.section]
        }
        guard let returnAttribute = attribute else {
            return UICollectionViewLayoutAttributes()
        }
        return returnAttribute
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var begin = 0, end = self.unionRects.count
        var attrs: [UICollectionViewLayoutAttributes] = []

        for i in 0 ..< end {
            let unionRect = self.unionRects[i]
            if rect.intersects(unionRect.cgRectValue) {
                begin = i * unionSize
                break
            }
        }
        for i in (0 ..< self.unionRects.count).reversed() {
            let unionRect = self.unionRects[i]
            if rect.intersects(unionRect.cgRectValue) {
                end = min((i + 1) * unionSize, self.allItemAttributes.count)
                break
            }
        }
        for i in begin ..< end {
            let attr = self.allItemAttributes[i]
            if rect.intersects(attr.frame) {
                attrs.append(attr)
            }
        }

        return attrs
    }

    override public func shouldInvalidateLayout (forBoundsChange newBounds: CGRect) -> Bool {
        let oldBounds = self.collectionView!.bounds
        if newBounds.width != oldBounds.width {
            return true
        }
        return false
    }


    /**
     *  Find the shortest column.
     *
     *  @return index for the shortest column
     */
    public func shortestColumnIndexInSection (_ section: Int) -> Int {
        var index = 0
        var shorestHeight = CGFloat.greatestFiniteMagnitude
        for (idx, height) in self.columnHeights[section].enumerated() {
            if height < shorestHeight {
                shorestHeight = height
                index = idx
            }
        }
        return index
    }

    /**
     *  Find the longest column.
     *
     *  @return index for the longest column
     */

    public func longestColumnIndexInSection (_ section: Int) -> Int {
        var index = 0
        var longestHeight: CGFloat = 0.0

        for (idx, height) in self.columnHeights[section].enumerated() {
            if height > longestHeight {
                longestHeight = height
                index = idx
            }
        }
        return index

    }

    /**
     *  Find the index for the next column.
     *
     *  @return index for the next column
     */
    public func nextColumnIndexForItem (_ item: Int, section: Int) -> Int {
        var index = 0
        let columnCount = self.columnCountForSection(section)
        switch self.itemRenderDirection {
        case .chtCollectionViewWaterfallLayoutItemRenderDirectionShortestFirst :
            index = self.shortestColumnIndexInSection(section)
        case .chtCollectionViewWaterfallLayoutItemRenderDirectionLeftToRight :
            index = (item%columnCount)
        case .chtCollectionViewWaterfallLayoutItemRenderDirectionRightToLeft:
            index = (columnCount - 1) - (item % columnCount)
        }
        return index
    }
}
