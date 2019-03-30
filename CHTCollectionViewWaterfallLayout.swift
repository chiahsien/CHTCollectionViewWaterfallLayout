//
//  CHTCollectionViewWaterfallLayout.swift
//  PinterestSwift
//
//  Created by Nicholas Tau on 6/30/14.
//  Copyright (c) 2014 Nicholas Tau. All rights reserved.
//

import UIKit

private func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

private func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


@objc public protocol CHTCollectionViewDelegateWaterfallLayout: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize

    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       heightForHeaderIn section: Int) -> CGFloat

    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       heightForFooterIn section: Int) -> CGFloat

    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       insetsFor section: Int) -> UIEdgeInsets

    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       minimumInteritemSpacingFor section: Int) -> CGFloat

    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       columnCountFor section: Int) -> Int

    @available(*, unavailable, renamed: "collectionView(_:layout:sizeForItemAt:)")
    @objc optional func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize

    @available(*, unavailable, renamed: "collectionView(_:layout:heightForHeaderIn:)")
    @objc optional func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                        heightForHeaderInSection section: Int) -> CGFloat

    @available(*, unavailable, renamed: "collectionView(_:layout:heightForFooterIn:)")
    @objc optional func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                        heightForFooterInSection section: Int) -> CGFloat

    @available(*, unavailable, renamed: "collectionView(_:layout:insetsFor:)")
    @objc optional func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                        insetForSectionAtIndex section: Int) -> UIEdgeInsets

    @available(*, unavailable, renamed: "collectionView(_:layout:minimumInteritemSpacingFor:)")
    @objc optional func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat

    @available(*, unavailable, renamed: "collectionView(_:layout:columnCountFor:)")
    @objc optional func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                        columnCountForSection section: Int) -> Int
}

@available(*, unavailable, renamed: "CHTCollectionViewWaterfallLayout.ItemRenderDirection")
public enum CHTCollectionViewWaterfallLayoutItemRenderDirection { }

public extension CHTCollectionViewWaterfallLayout.ItemRenderDirection {
    @available(*, unavailable, renamed: "shortestFirst")
    static let chtCollectionViewWaterfallLayoutItemRenderDirectionShortestFirst = 0
    @available(*, unavailable, renamed: "leftToRight")
    static let chtCollectionViewWaterfallLayoutItemRenderDirectionLeftToRight = 1
    @available(*, unavailable, renamed: "rightToLeft")
    static let chtCollectionViewWaterfallLayoutItemRenderDirectionRightToLeft = 2
}

extension CHTCollectionViewWaterfallLayout {
    public enum ItemRenderDirection: Int {
        case shortestFirst
        case leftToRight
        case rightToLeft
    }
    
    public enum SectionInsetReference {
        case fromContentInset
        case fromLayoutMargins
        @available(iOS 11, *)
        case fromSafeArea
    }
}

@available(*, unavailable, renamed: "UICollectionView.elementKindSectionHeader")
public let CHTCollectionElementKindSectionHeader = "CHTCollectionElementKindSectionHeader"
@available(*, unavailable, renamed: "UICollectionView.elementKindSectionFooter")
public let CHTCollectionElementKindSectionFooter = "CHTCollectionElementKindSectionFooter"
public class CHTCollectionViewWaterfallLayout: UICollectionViewLayout {
    public var columnCount: Int = 2 {
        didSet {
            invalidateLayout()
        }
    }

    public var minimumColumnSpacing: CGFloat = 10 {
        didSet {
            invalidateLayout()
        }
    }

    public var minimumInteritemSpacing: CGFloat = 10 {
        didSet {
            invalidateLayout()
        }
    }

    public var headerHeight: CGFloat = 0 {
        didSet {
            invalidateLayout()
        }
    }

    public var footerHeight: CGFloat = 0 {
        didSet {
            invalidateLayout()
        }
    }

    public var sectionInset: UIEdgeInsets = .zero {
        didSet {
            invalidateLayout()
        }
    }

    public var itemRenderDirection: ItemRenderDirection = .shortestFirst {
        didSet {
            invalidateLayout()
        }
    }

    public var sectionInsetReference: SectionInsetReference = .fromContentInset {
        didSet {
            invalidateLayout()
        }
    }

    public var delegate: CHTCollectionViewDelegateWaterfallLayout? {
        get {
            return collectionView!.delegate as? CHTCollectionViewDelegateWaterfallLayout
        }
    }

    private var columnHeights: [[CGFloat]] = []
    private var sectionItemAttributes: [[UICollectionViewLayoutAttributes]] = []
    private var allItemAttributes: [UICollectionViewLayoutAttributes] = []
    private var headersAttributes: [Int: UICollectionViewLayoutAttributes] = [:]
    private var footersAttributes: [Int: UICollectionViewLayoutAttributes] = [:]
    private var unionRects: [CGRect] = []
    private let unionSize = 20

    private func columnCount(forSection section: Int) -> Int {
        return delegate?.collectionView?(collectionView!, layout: self, columnCountFor: section) ?? columnCount
    }

    private var collectionViewContentWidth: CGFloat {
        let insets: UIEdgeInsets
        switch sectionInsetReference {
        case .fromContentInset:
            insets = collectionView!.contentInset
        case .fromSafeArea:
            if #available(iOS 11.0, *) {
                insets = collectionView!.safeAreaInsets
            } else {
                insets = .zero
            }
        case .fromLayoutMargins:
            insets = collectionView!.layoutMargins
        }
        return collectionView!.bounds.size.width - insets.left - insets.right
    }

    private func collectionViewContentWidth(ofSection section: Int) -> CGFloat {
        let insets = delegate?.collectionView?(collectionView!, layout: self, insetsFor: section) ?? sectionInset
        return collectionViewContentWidth - insets.left - insets.right
    }
    
    @available(*, unavailable, renamed: "itemWidth(inSection:)")
    public func itemWidthInSectionAtIndex(_ section: Int) -> CGFloat {
        return itemWidth(inSection: section)
    }

    public func itemWidth(inSection section: Int) -> CGFloat {
        let columnCount = self.columnCount(forSection: section)
        let spaceColumCount = CGFloat(columnCount - 1)
        let width = collectionViewContentWidth(ofSection: section)
        return floor((width - (spaceColumCount * minimumColumnSpacing)) / CGFloat(columnCount))
    }

    override public func prepare() {
        super.prepare()

        let numberOfSections = collectionView!.numberOfSections
        if numberOfSections == 0 {
            return
        }

        headersAttributes = [:]
        footersAttributes = [:]
        unionRects = []
        allItemAttributes = []
        sectionItemAttributes = []
        columnHeights = (0 ..< numberOfSections).map { section in
            let columnCount = self.columnCount(forSection: section)
            let sectionColumnHeights = (0 ..< columnCount).map { CGFloat($0) }
            return sectionColumnHeights
        }

        var top: CGFloat = 0.0
        var attributes = UICollectionViewLayoutAttributes()

        for section in 0 ..< numberOfSections {
            // MARK: 1. Get section-specific metrics (minimumInteritemSpacing, sectionInset)
            let minimumInteritemSpacing = delegate?.collectionView?(collectionView!, layout: self, minimumInteritemSpacingFor: section)
                ?? self.minimumInteritemSpacing
            let sectionInsets = delegate?.collectionView?(collectionView!, layout: self, insetsFor: section) ?? self.sectionInset
            let columnCount = columnHeights[section].count
            let itemWidth = self.itemWidth(inSection: section)

            // MARK: 2. Section header
            let heightHeader = delegate?.collectionView?(collectionView!, layout: self, heightForHeaderIn: section)
                ?? self.headerHeight
            if heightHeader > 0 {
                attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(row: 0, section: section))
                attributes.frame = CGRect(x: 0, y: top, width: collectionView!.bounds.size.width, height: heightHeader)
                headersAttributes[section] = attributes
                allItemAttributes.append(attributes)

                top = attributes.frame.maxY
            }
            top += sectionInsets.top
            columnHeights[section] = [CGFloat](repeating: top, count: columnCount)

            // MARK: 3. Section items
            let itemCount = collectionView!.numberOfItems(inSection: section)
            var itemAttributes: [UICollectionViewLayoutAttributes] = []

            // Item will be put into shortest column.
            for idx in 0 ..< itemCount {
                let indexPath = IndexPath(item: idx, section: section)

                let columnIndex = nextColumnIndexForItem(idx, inSection: section)
                let xOffset = sectionInsets.left + (itemWidth + minimumColumnSpacing) * CGFloat(columnIndex)

                let yOffset = columnHeights[section][columnIndex]
                var itemHeight: CGFloat = 0.0
                if let itemSize = delegate?.collectionView(collectionView!, layout: self, sizeForItemAt: indexPath),
                    itemSize.height > 0 {
                    itemHeight = itemSize.height
                    if itemSize.width > 0 {
                        itemHeight = floor(itemHeight * itemWidth / itemSize.width)
                    } // else use default item width based on other parameters
                }

                attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: itemHeight)
                itemAttributes.append(attributes)
                allItemAttributes.append(attributes)
                columnHeights[section][columnIndex] = attributes.frame.maxY + minimumInteritemSpacing
            }
            sectionItemAttributes.append(itemAttributes)

            // MARK: 4. Section footer
            let columnIndex  = longestColumnIndex(inSection: section)
            top = columnHeights[section][columnIndex] - minimumInteritemSpacing + sectionInsets.bottom
            let footerHeight = delegate?.collectionView?(collectionView!, layout: self, heightForFooterIn: section) ?? self.footerHeight

            if footerHeight > 0 {
                attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(item: 0, section: section))
                attributes.frame = CGRect(x: 0, y: top, width: collectionView!.bounds.size.width, height: footerHeight)
                footersAttributes[section] = attributes
                allItemAttributes.append(attributes)
                top = attributes.frame.maxY
            }

            columnHeights[section] = [CGFloat](repeating: top, count: columnCount)
        }

        var idx = 0
        let itemCounts = allItemAttributes.count
        while idx < itemCounts {
            let rect1 = allItemAttributes[idx].frame
            idx = min(idx + unionSize, itemCounts) - 1
            let rect2 = allItemAttributes[idx].frame
            unionRects.append(rect1.union(rect2))
            idx += 1
        }
    }

    override public var collectionViewContentSize: CGSize {
        if collectionView!.numberOfSections == 0 {
            return .zero
        }

        var contentSize = collectionView!.bounds.size
        contentSize.width = collectionViewContentWidth

        if let height = columnHeights.last?.first {
            contentSize.height = height
            return contentSize
        }
        return .zero
    }

    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.section >= sectionItemAttributes.count {
            return nil
        }
        let list = sectionItemAttributes[indexPath.section]
        if indexPath.item >= list.count {
            return nil
        }
        return list[indexPath.item]
    }

    override public func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        var attribute: UICollectionViewLayoutAttributes?
        if elementKind == UICollectionView.elementKindSectionHeader {
            attribute = headersAttributes[indexPath.section]
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            attribute = footersAttributes[indexPath.section]
        }
        return attribute ?? UICollectionViewLayoutAttributes()
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var begin = 0, end = unionRects.count

        if let i = unionRects.firstIndex(where: { rect.intersects($0) }) {
            begin = i * unionSize
        }
        if let i = unionRects.lastIndex(where: { rect.intersects($0) }) {
            end = min((i + 1) * unionSize, allItemAttributes.count)
        }
        return allItemAttributes[begin..<end]
            .filter { rect.intersects($0.frame) }
    }

    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds.width != collectionView?.bounds.width
    }

    /// Find the shortest column.
    ///
    /// - Returns: index for the shortest column
    private func shortestColumnIndex(inSection section: Int) -> Int {
        return columnHeights[section].enumerated()
            .min(by: { $0.element < $1.element })?
            .offset ?? 0
    }

    /// Find the longest column.
    ///
    /// - Returns: index for the longest column
    private func longestColumnIndex(inSection section: Int) -> Int {
        return columnHeights[section].enumerated()
            .max(by: { $0.element < $1.element })?
            .offset ?? 0
    }

    /// Find the index for the next column.
    ///
    /// - Returns: index for the next column
    private func nextColumnIndexForItem(_ item: Int, inSection section: Int) -> Int {
        var index = 0
        let columnCount = self.columnCount(forSection: section)
        switch itemRenderDirection {
        case .shortestFirst :
            index = shortestColumnIndex(inSection: section)
        case .leftToRight :
            index = item % columnCount
        case .rightToLeft:
            index = (columnCount - 1) - (item % columnCount)
        }
        return index
    }
}
