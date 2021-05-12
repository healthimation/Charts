//
//  BarLineScatterCandleBubbleRenderer.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

@objc(BarLineScatterCandleBubbleChartRenderer)
open class BarLineScatterCandleBubbleRenderer: DataRenderer
{
    internal var _xBounds = XBounds() // Reusable XBounds object
    
    public override init(animator: Animator, viewPortHandler: ViewPortHandler)
    {
        super.init(animator: animator, viewPortHandler: viewPortHandler)
    }
    
    /// Checks if the provided entry object is in bounds for drawing considering the current animation phase.
    internal func isInBoundsX(entry e: ChartDataEntry, dataSet: IBarLineScatterCandleBubbleChartDataSet) -> Bool
    {
        let entryIndex = dataSet.entryIndex(entry: e)
        return Double(entryIndex) < Double(dataSet.entryCount) * animator.phaseX
    }

    /// Calculates and returns the x-bounds for the given DataSet in terms of index in their values array.
    /// This includes minimum and maximum visible x, as well as range.
    internal func xBounds(chart: BarLineScatterCandleBubbleChartDataProvider,
                          dataSet: IBarLineScatterCandleBubbleChartDataSet,
                          animator: Animator?) -> XBounds
    {
        return XBounds(chart: chart, dataSet: dataSet, animator: animator)
    }
    
    /// - Returns: `true` if the DataSet values should be drawn, `false` if not.
    internal func shouldDrawValues(forDataSet set: IChartDataSet) -> Bool
    {
        return set.isVisible && (set.isDrawValuesEnabled || set.isDrawIconsEnabled)
    }

    /// Class representing the bounds of the current viewport in terms of indices in the values array of a DataSet.
    open class XBounds
    {
        /// minimum visible entry index
        open var min: Int = 0

        /// maximum visible entry index
        open var max: Int = 0

        /// range of visible entry indices
        open var range: Int = 0

        public init()
        {
            
        }
        
        public init(chart: BarLineScatterCandleBubbleChartDataProvider,
                    dataSet: IBarLineScatterCandleBubbleChartDataSet,
                    animator: Animator?)
        {
            self.set(chart: chart, dataSet: dataSet, animator: animator)
        }
        
        /// Calculates the minimum and maximum x values as well as the range between them.
        open func set(chart: BarLineScatterCandleBubbleChartDataProvider,
                      dataSet: IBarLineScatterCandleBubbleChartDataSet,
                      animator: Animator?)
        {
            let phaseX = Swift.max(0.0, Swift.min(1.0, animator?.phaseX ?? 1.0))
            
            let low = chart.lowestVisibleX
            let high = chart.highestVisibleX
            
            let entryFrom = dataSet.entryForXValue(low, closestToY: .nan, rounding: .down)
            let entryTo = dataSet.entryForXValue(high, closestToY: .nan, rounding: .up)
            
            self.min = entryFrom == nil ? 0 : dataSet.entryIndex(entry: entryFrom!)
            self.max = entryTo == nil ? 0 : dataSet.entryIndex(entry: entryTo!)
            range = Int(Double(self.max - self.min) * phaseX)
        }
    }

    // WARNING: tested only with linecharts / bar charts
    // Probably need some efforts to be able to work on other charts  
    internal func drawHighlightArrow(context: CGContext, point: CGPoint, set: IBarLineScatterCandleBubbleChartDataSet, insetBottom: CGFloat) {
        
        let strokeWidth = set.highlightLineWidth;
        let color = set.highlightColor.cgColor;
        let number = 2.0;
        let basicHeight = (CGFloat) (Double(strokeWidth)/number.squareRoot());
        let x = point.x;
        let y = point.y;

        let topPointOfArrowHead = viewPortHandler.contentTop;
        let bottomPointOfArrow = y - insetBottom;
        let topPointOfArrow = topPointOfArrowHead + basicHeight;
        

        let arrowHeadHeight = CGFloat(4.0) * basicHeight;
        let arrowHeadHalfWidth = CGFloat(3.0) * basicHeight;

        let baseSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [color, UIColor.clear.cgColor] as CFArray
        let locations = [CGFloat(0.6), CGFloat(1.0)]
        let gradient = CGGradient(colorsSpace: baseSpace, colors: colors, locations: locations)!

        // ACTUALLY DRAWING THE ARROW
        context.setStrokeColor(color)
        context.setLineWidth(strokeWidth)

        context.saveGState()
        context.beginPath()

        context.move(to: CGPoint(x: x, y: topPointOfArrow))
        context.addLine(to: CGPoint(x: x, y: bottomPointOfArrow))
        // context.strokePath()
        context.replacePathWithStrokedPath()
        context.clip()

        context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: topPointOfArrow), end: CGPoint(x: 0, y: bottomPointOfArrow), options: [])
        context.restoreGState()
        // ----------------------------------------------------------------
        context.beginPath()

        context.move(to: CGPoint(x: x - arrowHeadHalfWidth, y: topPointOfArrowHead + arrowHeadHeight))
        context.addLine(to: CGPoint(x: x + basicHeight/2, y: topPointOfArrowHead + basicHeight/2))
        context.move(to: CGPoint(x: x - basicHeight/2, y: topPointOfArrowHead + basicHeight/2))
        context.addLine(to: CGPoint(x: x + arrowHeadHalfWidth, y: topPointOfArrowHead + arrowHeadHeight))
        context.strokePath()
    }
}

extension BarLineScatterCandleBubbleRenderer.XBounds: RangeExpression {
    public func relative<C>(to collection: C) -> Swift.Range<Int>
        where C : Collection, Bound == C.Index
    {
        return Swift.Range<Int>(min...min + range)
    }

    public func contains(_ element: Int) -> Bool {
        return (min...min + range).contains(element)
    }
}

extension BarLineScatterCandleBubbleRenderer.XBounds: Sequence {
    public struct Iterator: IteratorProtocol {
        private var iterator: IndexingIterator<ClosedRange<Int>>
        
        fileprivate init(min: Int, max: Int) {
            self.iterator = (min...max).makeIterator()
        }
        
        public mutating func next() -> Int? {
            return self.iterator.next()
        }
    }
    
    public func makeIterator() -> Iterator {
        return Iterator(min: self.min, max: self.max)
    }
}
