//
//  InspectableAirSegmentedControl.swift
//  AirSegmentedControl
//
//  Created by Steven Thompson on 2017-02-20.
//  Copyright © 2017 airg. All rights reserved.
//

import Foundation
import AirSegmentedControl

/// Include this in your project to gain @IBInspectable
class InspectableAirSegmentedControl: AirSegmentedControl {
    @IBInspectable override open var commaSeparatedSegments: String {
        get {
            return super.commaSeparatedSegments
        }
        set {
            super.commaSeparatedSegments = newValue
        }
    }

    /// Controls how quickly the underline moves between sections. `valueChanged` is always sent immediately.
    @IBInspectable override open var animationTime: Double {
        get {
            return super.animationTime
        }
        set {
            super.animationTime = newValue
        }
    }

    /// When `true`, only sends a `valueChanged` when the value changes to something different.
    @IBInspectable override open var shouldIgnoreDuplicateInputs: Bool {
        get {
            return super.shouldIgnoreDuplicateInputs
        }
        set {
            super.shouldIgnoreDuplicateInputs = newValue
        }
    }

    /// The color of the underline
    @IBInspectable override open var underlineColor: UIColor {
        get {
            return super.underlineColor
        }
        set {
            super.underlineColor = newValue
        }
    }

    /// The height of the underline
    @IBInspectable override open var underlineHeight: Int {
        get {
            return super.underlineHeight
        }
        set {
            super.underlineHeight = newValue
        }
    }

    /// The color of the segment text when selected
    @IBInspectable override open var textColorSelected: UIColor {
        get {
            return super.textColorSelected
        }
        set {
            super.textColorSelected = newValue
        }
    }

    /// The text color of all unselected segments
    @IBInspectable override open var textColorUnselected: UIColor {
        get {
            return super.textColorUnselected
        }
        set {
            super.textColorUnselected = newValue
        }
    }

    /// Whether to show a bottom border
    @IBInspectable override open var bottomBorderVisible: Bool {
        get {
            return super.bottomBorderVisible
        }
        set {
            super.bottomBorderVisible = newValue
        }
    }

    /// The color of the bottom border, if it's visible
    @IBInspectable override open var bottomBorderColor: UIColor {
        get {
            return super.bottomBorderColor
        }
        set {
            super.bottomBorderColor = newValue
        }
    }

    /// The height of the bottom border
    @IBInspectable override open var bottomBorderHeight: Int {
        get {
            return super.bottomBorderHeight
        }
        set {
            super.bottomBorderHeight = newValue
        }
    }

    // These are required to fix build issues, no benefit having it here otherwise
    override var textFont: UIFont {
        get {
            return super.textFont
        }
        set {
            super.textFont = newValue
        }
    }

    override var segments: [String] {
        get {
            return super.segments
        }
    }

    override var selectedSegmentIndex: Int {
        get {
            return super.selectedSegmentIndex
        }
    }
}
