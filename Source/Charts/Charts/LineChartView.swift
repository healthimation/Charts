//
//  LineChartView.swift
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

/// Chart that draws lines, surfaces, circles, ...
open class LineChartView: BarLineChartViewBase, LineChartDataProvider
{

    private var _enableGroupHighlighter = false

    @objc open var enableGroupHighlighter: Bool {
        get { return _enableGroupHighlighter }
        set {
            _enableGroupHighlighter = newValue
            if(newValue) {
                self.highlighter = GroupLineHighlighter(chart: self)
            } else {
                self.highlighter = ChartHighlighter(chart: self)
            }
        }
    }

    @objc open var isGroupSelectionEnabled: Bool
    {
        return _enableGroupHighlighter
    }

    internal override func initialize()
    {
        super.initialize()
        
        renderer = LineChartRenderer(dataProvider: self, animator: _animator, viewPortHandler: _viewPortHandler)
    }
    
    // MARK: - LineChartDataProvider
    
    open var lineData: LineChartData? { return _data as? LineChartData }
}
