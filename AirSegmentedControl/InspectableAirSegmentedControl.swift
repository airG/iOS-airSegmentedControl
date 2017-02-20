//
//  InspectableAirSegmentedControl.swift
//  AirSegmentedControl
//
//  Created by Steven Thompson on 2017-02-20.
//  Copyright © 2017 airg. All rights reserved.
//

import Foundation

// Include this in your project to gain @IBInspectable
class InspectableAirSegmentedControl: AirSegmentedControl {
    @IBInspectable public var commaSeparatedSegments: String {
        get {
            return super.commaSeparatedSegments
        }
        set {
            super.commaSeparatedSegments = newValue
        }
    }

    /// Controls how quickly the underline moves between sections. `valueChanged` is always sent immediately.
    @IBInspectable public var animationTime: Double {
        get {
            return super.animationTime
        }
        set {
            super.animationTime = newValue
        }
    }

    /// When `true`, only sends a `valueChanged` when the value changes to something different.
    @IBInspectable public var shouldIgnoreDuplicateInputs: Bool {
        get {
            return super.shouldIgnoreDuplicateInputs
        }
        set {
            super.shouldIgnoreDuplicateInputs = newValue
        }
    }

    /// The color of the underline
    @IBInspectable public var underlineColor: UIColor {
        get {
            return super.underlineColor
        }
        set {
            super.underlineColor = newValue
        }
    }

    /// The height of the underline
    @IBInspectable public var underlineHeight: Int {
        get {
            return super.underlineHeight
        }
        set {
            super.underlineHeight = newValue
        }
    }

    /// The color of the segment text when selected
    @IBInspectable public var textColorSelected: UIColor {
        get {
            return super.textColorSelected
        }
        set {
            super.textColorSelected = newValue
        }
    }

    /// The text color of all unselected segments
    @IBInspectable public var textColorUnselected: UIColor {
        get {
            return super.textColorUnselected
        }
        set {
            super.textColorUnselected = newValue
        }
    }

    /// Font
    public var textFont: UIFont {
        get {
            return super.textFont
        }
        set {
            super.textFont = newValue
        }
    }

    /// Whether to show a bottom border
    @IBInspectable public var bottomBorderVisible: Bool {
        get {
            return super.bottomBorderVisible
        }
        set {
            super.bottomBorderVisible = newValue
        }
    }

    /// The color of the bottom border, if it's visible
    @IBInspectable public var bottomBorderColor: UIColor {
        get {
            return super.bottomBorderColor
        }
        set {
            super.bottomBorderColor = newValue
        }
    }

    /// The height of the bottom border
    @IBInspectable public var bottomBorderHeight: Int {
        get {
            return super.bottomBorderHeight
        }
        set {
            super.bottomBorderHeight = newValue
        }
    }
}
