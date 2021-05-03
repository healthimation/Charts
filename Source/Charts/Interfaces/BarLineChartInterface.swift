//
//  BarChartDataProvider.swift
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

@objc
public protocol BarLineChartInterface: BarLineScatterCandleBubbleChartDataProvider
{
    var isEnlargeEntryOnHighlightEnabled: Bool { get }
    var isMakeUnhighlightedEntriesSmalledEnabled: Bool { get }
    var isDimmingEnabled: Bool { get }

    var getEnlargementScaleForHighlightedEntry: CGFloat { get }
    var getDecreaseScaleForUnhighlightedEntry: CGFloat { get }
    var getDimmingAlpha: NSInteger { get }
}