//
//  CHTCollectionViewWaterfallLayout.swift
//
//  Created by Nelson on 12/11/19.
//  Copyright (c) 2012 Nelson Tai. All rights reserved.
//

import UIKit

// MARK: - CHTCollectionViewDelegateWaterfallLayout

/// A protocol that lets you coordinate with a waterfall layout object to implement a waterfall-based layout.
///
/// The methods of this protocol define the size of items and the spacing around them. All of the methods
/// in this protocol are optional except ``collectionView(_:layout:sizeForItemAt:)``. The waterfall layout
/// object expects the collection view's delegate to adopt this protocol. Therefore, implement this protocol
/// on the object assigned to your collection view's ``UICollectionView/delegate`` property.
@objc public protocol CHTCollectionViewDelegateWaterfallLayout: UICollectionViewDelegate {

    /// Asks the delegate for the size of the specified item's cell.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view object displaying the waterfall layout.
    ///   - collectionViewLayout: The layout object requesting the information.
    ///   - indexPath: The index path of the item.
    /// - Returns: The original size of the specified item. Both width and height must be greater than `0`.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize

    /// Asks the delegate for the column count in a section.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view object displaying the waterfall layout.
    ///   - collectionViewLayout: The layout object requesting the information.
    ///   - section: The index of the section.
    /// - Returns: The column count for the section. Must be greater than 0.
    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       columnCountFor section: Int) -> Int

    /// Asks the delegate for the height of the header view in the specified section.
    ///
    /// If you do not implement this method, the layout uses the value in its ``CHTCollectionViewWaterfallLayout/headerHeight``
    /// property to set the size of the header.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view object displaying the waterfall layout.
    ///   - collectionViewLayout: The layout object requesting the information.
    ///   - section: The index of the section whose header size is being requested.
    /// - Returns: The height of the header. If you return 0, no header is added.
    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       heightForHeaderIn section: Int) -> CGFloat

    /// Asks the delegate for the height of the footer view in the specified section.
    ///
    /// If you do not implement this method, the layout uses the value in its ``CHTCollectionViewWaterfallLayout/footerHeight``
    /// property to set the size of the footer.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view object displaying the waterfall layout.
    ///   - collectionViewLayout: The layout object requesting the information.
    ///   - section: The index of the section whose footer size is being requested.
    /// - Returns: The height of the footer. If you return 0, no footer is added.
    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       heightForFooterIn section: Int) -> CGFloat

    /// Asks the delegate for the insets in the specified section.
    ///
    /// If you do not implement this method, the layout uses the value in its ``CHTCollectionViewWaterfallLayout/sectionInset``
    /// property.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view object displaying the waterfall layout.
    ///   - collectionViewLayout: The layout object requesting the information.
    ///   - section: The index of the section whose insets are being requested.
    /// - Returns: The insets for the section.
    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       insetsFor section: Int) -> UIEdgeInsets

    /// Asks the delegate for the header insets in the specified section.
    ///
    /// If you do not implement this method, the layout uses the value in its ``CHTCollectionViewWaterfallLayout/headerInset``
    /// property.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view object displaying the waterfall layout.
    ///   - collectionViewLayout: The layout object requesting the information.
    ///   - section: The index of the section whose header insets are being requested.
    /// - Returns: The header insets for the section.
    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       insetsForHeaderIn section: Int) -> UIEdgeInsets

    /// Asks the delegate for the footer insets in the specified section.
    ///
    /// If you do not implement this method, the layout uses the value in its ``CHTCollectionViewWaterfallLayout/footerInset``
    /// property.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view object displaying the waterfall layout.
    ///   - collectionViewLayout: The layout object requesting the information.
    ///   - section: The index of the section whose footer insets are being requested.
    /// - Returns: The footer insets for the section.
    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       insetsForFooterIn section: Int) -> UIEdgeInsets

    /// Asks the delegate for the minimum spacing between two items in the same column in the specified section.
    ///
    /// If you do not implement this method, the layout uses the value in its
    /// ``CHTCollectionViewWaterfallLayout/minimumInteritemSpacing`` property to determine the amount of space
    /// between items in the same column.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view object displaying the waterfall layout.
    ///   - collectionViewLayout: The layout object requesting the information.
    ///   - section: The index of the section whose minimum interitem spacing is being requested.
    /// - Returns: The minimum interitem spacing.
    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       minimumInteritemSpacingFor section: Int) -> CGFloat

    /// Asks the delegate for the minimum spacing between columns in the specified section.
    ///
    /// If you do not implement this method, the layout uses the value in its
    /// ``CHTCollectionViewWaterfallLayout/minimumColumnSpacing`` property to determine the amount of space
    /// between columns in each section.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view object displaying the waterfall layout.
    ///   - collectionViewLayout: The layout object requesting the information.
    ///   - section: The index of the section whose minimum column spacing is being requested.
    /// - Returns: The minimum spacing between each column.
    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       minimumColumnSpacingFor section: Int) -> CGFloat
}

// MARK: - Constants

/// A supplementary view that identifies the header for a given section.
public let CHTCollectionElementKindSectionHeader = "CHTCollectionElementKindSectionHeader"
/// A supplementary view that identifies the footer for a given section.
public let CHTCollectionElementKindSectionFooter = "CHTCollectionElementKindSectionFooter"

// MARK: - CHTCollectionViewWaterfallLayout

/// A concrete layout object that organizes items into a waterfall-based grid with optional header and
/// footer views for each section.
///
/// A waterfall layout works with the collection view's delegate object to determine the size of items,
/// headers, and footers in each section. That delegate object must conform to the
/// ``CHTCollectionViewDelegateWaterfallLayout`` protocol.
///
/// Each section in a waterfall layout can have its own custom header and footer. To configure the header
/// or footer for a view, you must configure the height of the header or footer to be non-zero. You can
/// do this by implementing the appropriate delegate methods or by assigning appropriate values to the
/// ``headerHeight`` and ``footerHeight`` properties. If the header or footer height is 0, the
/// corresponding view is not added to the collection view.
///
/// - Note: This layout doesn't support decoration views, and it supports vertical scrolling only.
public class CHTCollectionViewWaterfallLayout: UICollectionViewLayout {

    // MARK: Types

    /// The direction in which items are rendered in subsequent rows.
    public enum ItemRenderDirection: Int {
        /// Items fill the shortest column first.
        case shortestFirst
        /// Items are rendered from left to right.
        case leftToRight
        /// Items are rendered from right to left.
        case rightToLeft
    }

    /// The reference point for calculating section insets.
    public enum SectionInsetReference {
        /// Insets are calculated relative to the collection view's ``UIScrollView/contentInset``.
        case fromContentInset
        /// Insets are calculated relative to the collection view's ``UIView/layoutMargins``.
        case fromLayoutMargins
        /// Insets are calculated relative to the collection view's safe area.
        @available(iOS 11, *)
        case fromSafeArea
    }

    // MARK: Public Properties

    /// The number of columns for the layout.
    ///
    /// The default value is `2`.
    public var columnCount: Int = 2 {
        didSet {
            guard columnCount != oldValue else { return }
            invalidateLayout()
        }
    }

    /// The minimum spacing to use between successive columns.
    ///
    /// The default value is `10`.
    public var minimumColumnSpacing: CGFloat = 10 {
        didSet {
            guard minimumColumnSpacing != oldValue else { return }
            invalidateLayout()
        }
    }

    /// The minimum spacing to use between items in the same column.
    ///
    /// This spacing is not applied to the space between header and columns or between columns and footer.
    ///
    /// The default value is `10`.
    public var minimumInteritemSpacing: CGFloat = 10 {
        didSet {
            guard minimumInteritemSpacing != oldValue else { return }
            invalidateLayout()
        }
    }

    /// The default height for section headers.
    ///
    /// If the delegate does not implement
    /// ``CHTCollectionViewDelegateWaterfallLayout/collectionView(_:layout:heightForHeaderIn:)``,
    /// this value is used. The default value is `0`.
    public var headerHeight: CGFloat = 0 {
        didSet {
            guard headerHeight != oldValue else { return }
            invalidateLayout()
        }
    }

    /// The default height for section footers.
    ///
    /// If the delegate does not implement
    /// ``CHTCollectionViewDelegateWaterfallLayout/collectionView(_:layout:heightForFooterIn:)``,
    /// this value is used. The default value is `0`.
    public var footerHeight: CGFloat = 0 {
        didSet {
            guard footerHeight != oldValue else { return }
            invalidateLayout()
        }
    }

    /// The margins used to lay out the header for each section.
    ///
    /// These insets are applied to the headers in each section. They represent the distance between the
    /// top of the collection view and the top of the content items. They also indicate the spacing on
    /// either side of the header. They do not affect the size of the headers or footers themselves.
    ///
    /// The default value is ``UIEdgeInsets/zero``.
    public var headerInset: UIEdgeInsets = .zero {
        didSet {
            guard headerInset != oldValue else { return }
            invalidateLayout()
        }
    }

    /// The margins used to lay out the footer for each section.
    ///
    /// These insets are applied to the footers in each section. They represent the distance between the
    /// bottom of the content items and the footer. They also indicate the spacing on either side of the
    /// footer. They do not affect the size of the headers or footers themselves.
    ///
    /// The default value is ``UIEdgeInsets/zero``.
    public var footerInset: UIEdgeInsets = .zero {
        didSet {
            guard footerInset != oldValue else { return }
            invalidateLayout()
        }
    }

    /// The margins used to lay out content in each section.
    ///
    /// Section insets are margins applied only to the items in the section. They represent the distance
    /// between the header view and the columns and between the columns and the footer view. They also
    /// indicate the spacing on either side of columns. They do not affect the size of the headers or
    /// footers themselves.
    ///
    /// The default value is ``UIEdgeInsets/zero``.
    public var sectionInset: UIEdgeInsets = .zero {
        didSet {
            guard sectionInset != oldValue else { return }
            invalidateLayout()
        }
    }

    /// The direction in which items are rendered in subsequent rows.
    ///
    /// The default value is ``ItemRenderDirection/shortestFirst``.
    public var itemRenderDirection: ItemRenderDirection = .shortestFirst {
        didSet {
            guard itemRenderDirection != oldValue else { return }
            invalidateLayout()
        }
    }

    /// The minimum height of the collection view's content.
    ///
    /// Use this to allow hidden headers with no content. The default value is `0`.
    public var minimumContentHeight: CGFloat = 0 {
        didSet {
            guard minimumContentHeight != oldValue else { return }
            invalidateLayout()
        }
    }

    /// The reference point for calculating section insets.
    ///
    /// The default value is ``SectionInsetReference/fromContentInset``.
    public var sectionInsetReference: SectionInsetReference = .fromContentInset {
        didSet {
            guard sectionInsetReference != oldValue else { return }
            invalidateLayout()
        }
    }

    // MARK: Private Properties

    private var columnHeights: [[CGFloat]] = []
    private var sectionItemAttributes: [[UICollectionViewLayoutAttributes]] = []
    private var allItemAttributes: [UICollectionViewLayoutAttributes] = []
    private var headersAttributes: [Int: UICollectionViewLayoutAttributes] = [:]
    private var footersAttributes: [Int: UICollectionViewLayoutAttributes] = [:]
    private var unionRects: [CGRect] = []

    private let unionSize = 20

    private var delegate: CHTCollectionViewDelegateWaterfallLayout? {
        return collectionView?.delegate as? CHTCollectionViewDelegateWaterfallLayout
    }

    // MARK: Helpers

    private func floorToPixel(_ value: CGFloat) -> CGFloat {
        let scale = collectionView?.traitCollection.displayScale ?? 0
        let validScale = scale > 0 ? scale : 1
        return floor(value * validScale) / validScale
    }

    private func columnCount(forSection section: Int) -> Int {
        guard let collectionView else { return columnCount }
        return delegate?.collectionView?(collectionView, layout: self, columnCountFor: section) ?? columnCount
    }

    private func collectionViewContentWidth(of collectionView: UICollectionView) -> CGFloat {
        let insets: UIEdgeInsets
        switch sectionInsetReference {
        case .fromContentInset:
            insets = collectionView.contentInset
        case .fromSafeArea:
            if #available(iOS 11.0, *) {
                insets = collectionView.safeAreaInsets
            } else {
                insets = .zero
            }
        case .fromLayoutMargins:
            insets = collectionView.layoutMargins
        }
        return collectionView.bounds.size.width - insets.left - insets.right
    }

    /// The calculated width of an item in the specified section.
    ///
    /// The width is calculated based on the number of columns, the collection view width, and the
    /// horizontal insets for that section.
    ///
    /// - Parameter section: The index of the section.
    /// - Returns: The width of an item in the specified section.
    public func itemWidth(inSection section: Int) -> CGFloat {
        guard let collectionView else { return 0 }

        let sectionInset = delegate?.collectionView?(collectionView, layout: self, insetsFor: section) ?? self.sectionInset
        let width = collectionViewContentWidth(of: collectionView) - sectionInset.left - sectionInset.right
        let columnCount = self.columnCount(forSection: section)

        let columnSpacing = delegate?.collectionView?(collectionView, layout: self, minimumColumnSpacingFor: section)
            ?? minimumColumnSpacing

        return floorToPixel((width - CGFloat(columnCount - 1) * columnSpacing) / CGFloat(columnCount))
    }

    // MARK: UICollectionViewLayout Overrides

    public override func prepare() {
        super.prepare()

        guard let collectionView else { return }

        let numberOfSections = collectionView.numberOfSections
        guard numberOfSections > 0 else { return }

        assert(delegate != nil, "UICollectionView's delegate should conform to CHTCollectionViewDelegateWaterfallLayout protocol")
        assert(
            columnCount > 0 || delegate?.collectionView?(collectionView, layout: self, columnCountFor: 0) != nil,
            "CHTCollectionViewWaterfallLayout's columnCount should be greater than 0, or delegate must implement columnCountFor:"
        )

        // Reset cached state
        headersAttributes = [:]
        footersAttributes = [:]
        unionRects = []
        allItemAttributes = []
        sectionItemAttributes = []
        columnHeights = (0..<numberOfSections).map { section in
            let count = columnCount(forSection: section)
            return [CGFloat](repeating: 0, count: count)
        }

        // Build attributes
        var top: CGFloat = 0

        for section in 0..<numberOfSections {
            // 1. Get section-specific metrics
            let sectionColumnSpacing = delegate?.collectionView?(collectionView, layout: self, minimumColumnSpacingFor: section)
                ?? minimumColumnSpacing
            let interitemSpacing = delegate?.collectionView?(collectionView, layout: self, minimumInteritemSpacingFor: section)
                ?? self.minimumInteritemSpacing
            let sectionInset = delegate?.collectionView?(collectionView, layout: self, insetsFor: section)
                ?? self.sectionInset

            let contentWidth = collectionViewContentWidth(of: collectionView) - sectionInset.left - sectionInset.right
            let columnCount = columnHeights[section].count
            let itemWidth = floorToPixel((contentWidth - CGFloat(columnCount - 1) * sectionColumnSpacing) / CGFloat(columnCount))

            // 2. Section header
            let headerHeight = delegate?.collectionView?(collectionView, layout: self, heightForHeaderIn: section)
                ?? self.headerHeight
            let headerInset = delegate?.collectionView?(collectionView, layout: self, insetsForHeaderIn: section)
                ?? self.headerInset

            top += headerInset.top

            if headerHeight > 0 {
                let attributes = UICollectionViewLayoutAttributes(
                    forSupplementaryViewOfKind: CHTCollectionElementKindSectionHeader,
                    with: IndexPath(item: 0, section: section)
                )
                attributes.frame = CGRect(
                    x: headerInset.left,
                    y: top,
                    width: collectionView.bounds.size.width - (headerInset.left + headerInset.right),
                    height: headerHeight
                )
                headersAttributes[section] = attributes
                allItemAttributes.append(attributes)

                top = attributes.frame.maxY + headerInset.bottom
            }

            top += sectionInset.top
            columnHeights[section] = [CGFloat](repeating: top, count: columnCount)

            // 3. Section items
            let itemCount = collectionView.numberOfItems(inSection: section)
            var itemAttributes: [UICollectionViewLayoutAttributes] = []

            for idx in 0..<itemCount {
                let indexPath = IndexPath(item: idx, section: section)
                let columnIndex = nextColumnIndexForItem(idx, inSection: section)
                let xOffset = sectionInset.left + (itemWidth + sectionColumnSpacing) * CGFloat(columnIndex)
                let yOffset = columnHeights[section][columnIndex]

                let itemSize = delegate?.collectionView(collectionView, layout: self, sizeForItemAt: indexPath) ?? .zero
                var itemHeight: CGFloat = 0
                if itemSize.height > 0 && itemSize.width > 0 {
                    itemHeight = floorToPixel(itemSize.height * itemWidth / itemSize.width)
                }

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: itemHeight)
                itemAttributes.append(attributes)
                allItemAttributes.append(attributes)
                columnHeights[section][columnIndex] = attributes.frame.maxY + interitemSpacing
            }
            sectionItemAttributes.append(itemAttributes)

            // 4. Section footer
            let columnIndex = longestColumnIndex(inSection: section)
            if columnHeights[section].isEmpty {
                top = 0
            } else {
                top = columnHeights[section][columnIndex] - interitemSpacing + sectionInset.bottom
            }

            let footerHeight = delegate?.collectionView?(collectionView, layout: self, heightForFooterIn: section)
                ?? self.footerHeight
            let footerInset = delegate?.collectionView?(collectionView, layout: self, insetsForFooterIn: section)
                ?? self.footerInset

            top += footerInset.top

            if footerHeight > 0 {
                let attributes = UICollectionViewLayoutAttributes(
                    forSupplementaryViewOfKind: CHTCollectionElementKindSectionFooter,
                    with: IndexPath(item: 0, section: section)
                )
                attributes.frame = CGRect(
                    x: footerInset.left,
                    y: top,
                    width: collectionView.bounds.size.width - (footerInset.left + footerInset.right),
                    height: footerHeight
                )
                footersAttributes[section] = attributes
                allItemAttributes.append(attributes)

                top = attributes.frame.maxY + footerInset.bottom
            }

            columnHeights[section] = [CGFloat](repeating: top, count: columnCount)
        }

        // Build union rects
        var idx = 0
        let itemCounts = allItemAttributes.count
        while idx < itemCounts {
            var unionRect = allItemAttributes[idx].frame
            let rectEndIndex = min(idx + unionSize, itemCounts)
            for i in (idx + 1)..<rectEndIndex {
                unionRect = unionRect.union(allItemAttributes[i].frame)
            }
            idx = rectEndIndex
            unionRects.append(unionRect)
        }
    }

    public override var collectionViewContentSize: CGSize {
        guard let collectionView else { return .zero }
        guard collectionView.numberOfSections > 0 else { return .zero }

        var contentSize = collectionView.bounds.size
        let height = columnHeights.last?.first ?? 0
        contentSize.height = max(height, minimumContentHeight)
        return contentSize
    }

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.section < sectionItemAttributes.count else { return nil }
        let list = sectionItemAttributes[indexPath.section]
        guard indexPath.item < list.count else { return nil }
        return list[indexPath.item]
    }

    public override func layoutAttributesForSupplementaryView(
        ofKind elementKind: String,
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        if elementKind == CHTCollectionElementKindSectionHeader
            || elementKind == UICollectionView.elementKindSectionHeader {
            return headersAttributes[indexPath.section]
        } else if elementKind == CHTCollectionElementKindSectionFooter
            || elementKind == UICollectionView.elementKindSectionFooter {
            return footersAttributes[indexPath.section]
        }
        return nil
    }

    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var begin = 0
        var end = unionRects.count

        if let i = unionRects.firstIndex(where: { rect.intersects($0) }) {
            begin = i * unionSize
        }
        if let i = unionRects.lastIndex(where: { rect.intersects($0) }) {
            end = min((i + 1) * unionSize, allItemAttributes.count)
        }

        var cellAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
        var headerAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
        var footerAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]

        for i in begin..<end {
            let attr = allItemAttributes[i]
            guard rect.intersects(attr.frame) else { continue }

            switch attr.representedElementCategory {
            case .cell:
                cellAttributes[attr.indexPath] = attr
            case .supplementaryView:
                if attr.representedElementKind == CHTCollectionElementKindSectionHeader {
                    headerAttributes[attr.indexPath] = attr
                } else if attr.representedElementKind == CHTCollectionElementKindSectionFooter {
                    footerAttributes[attr.indexPath] = attr
                }
            case .decorationView:
                break
            @unknown default:
                break
            }
        }

        return Array(cellAttributes.values)
            + Array(headerAttributes.values)
            + Array(footerAttributes.values)
    }

    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds.width != collectionView?.bounds.width
    }

    // MARK: Private Methods

    private func shortestColumnIndex(inSection section: Int) -> Int {
        return columnHeights[section].enumerated()
            .min(by: { $0.element < $1.element })?
            .offset ?? 0
    }

    private func longestColumnIndex(inSection section: Int) -> Int {
        return columnHeights[section].enumerated()
            .max(by: { $0.element < $1.element })?
            .offset ?? 0
    }

    private func nextColumnIndexForItem(_ item: Int, inSection section: Int) -> Int {
        let columnCount = self.columnCount(forSection: section)
        switch itemRenderDirection {
        case .shortestFirst:
            return shortestColumnIndex(inSection: section)
        case .leftToRight:
            return item % columnCount
        case .rightToLeft:
            return (columnCount - 1) - (item % columnCount)
        }
    }
}
