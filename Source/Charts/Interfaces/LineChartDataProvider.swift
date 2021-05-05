//
//  LineChartDataProvider.swift
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
public protocol LineChartDataProvider: BarLineChartInterface
{
    var lineData: LineChartData? { get }

    var isGroupSelectionEnabled: Bool {get}
    
    func getAxis(_ axis: YAxis.AxisDependency) -> YAxis
}
