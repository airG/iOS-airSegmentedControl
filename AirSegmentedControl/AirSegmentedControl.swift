//
//  AirSegmentedControl.swift
//  AirSegmentedControl
//
//  Created by Steven Thompson on 2017-02-17.
//  Copyright © 2017 airg. All rights reserved.
//

import Foundation

/// Create or modify the style to customize the `AirSegmentedControl`
public struct AirSegmentedControlStyle {
    /// Controls how quickly the underline moves between sections. This has no effect on the control action.
    public var animationTime: TimeInterval = 0.2

    /// The backgroundColor of the entire control
    public var backgroundColor: UIColor = .white

    /// The color of the underline
    public var underlineColor: UIColor = .darkGray

    /// The color of the segment text when selected
    public var selectedTextColor: UIColor = .black

    /// The text color of all unselected segments
    public var unselectedTextColor: UIColor = .darkGray

    /// When `true`, only sends a `valueChanged` when the value changes to something different.
    public var shouldIgnoreDuplicateInputs: Bool = true
}

/// Custom UIControl subclass
public class AirSegmentedControl: UIControl {
    /// The current style configuration of the control
    public fileprivate(set) var style: AirSegmentedControlStyle = AirSegmentedControlStyle()

    /// Array of `Segment` which are being displayed
    public fileprivate(set) var segments: [String] = []

    /// Get the currently selected segment index
    public fileprivate(set) var selectedSegmentIndex: Int = 0

    fileprivate let underline: UIView = UIView()
    fileprivate var underlineConstraints: [NSLayoutConstraint] = []

    public typealias Segment = String

    /// Configure the control with provided segments and style
    ///
    /// - Parameters:
    ///   - segments: Array of segments to display
    ///   - style: Optional style configuration, if `nil`
    public func configure(with segments: [Segment], style: AirSegmentedControlStyle = AirSegmentedControlStyle()) {
        self.style = style
        self.segments = segments

        setupView()
    }

    fileprivate func setupView() {
        backgroundColor = style.backgroundColor

        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.backgroundColor = style.underlineColor

        addSubview(underline)

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(2)]-(1)-|", options: [], metrics: nil, views: ["line": underline]))

        var previousButton: UIButton?

        for (index, title) in segments.enumerated() {
            let button = UIButton()
            button.setAttributedTitle(NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: style.unselectedTextColor]), for: .normal)
            button.setAttributedTitle(NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: UIColor.white]), for: .selected)
            button.setAttributedTitle(NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: UIColor.white]), for: .highlighted)
            button.tintColor = style.unselectedTextColor
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = index
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            addSubview(button)

            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[b]|", options: [], metrics: nil, views: ["b": button]))

            switch index {
            case 0:
                addConstraint(NSLayoutConstraint(item: underline, attribute: .width, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1, constant: 0))

                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[b]", options: [], metrics: nil, views: ["b": button]))

            case 1..<segments.count-1:
                addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: previousButton, attribute: .width, multiplier: 1, constant: 0))
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[previousB][b]", options: [], metrics: nil, views: ["previousB": previousButton!, "b": button]))

            case segments.count-1:
                addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: previousButton, attribute: .width, multiplier: 1, constant: 0))
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[previousB][b]|", options: [], metrics: nil, views: ["previousB": previousButton!, "b": button]))

            default:
                fatalError("Shouldn't get here")
            }
            let centerLine = NSLayoutConstraint(item: underline, attribute: .centerX, relatedBy: .equal, toItem: button, attribute: .centerX, multiplier: 1, constant: 0)
            centerLine.priority = 250
            addConstraint(centerLine)
            underlineConstraints.append(centerLine)

            if selectedSegmentIndex == index {
                button.isSelected = true
                constrainBottomLine(index)
            }

            previousButton = button
        }
    }

    @objc fileprivate func buttonTapped(_ sender: UIButton) {
        if style.shouldIgnoreDuplicateInputs && selectedSegmentIndex == sender.tag {
            return
        }
        select(at: sender.tag)
    }

    /// Select an index, sending a `valueChanged` event.
    ///
    /// - Parameters:
    ///   - index: Index to select
    ///   - animated: Should the selection be animated,
    public func select(at index: Int, animated: Bool = true) {
        selectedSegmentIndex = index

        for button in subviews where button is UIButton {
            let b = button as! UIButton

            if b.tag != index {
                b.isSelected = false
            } else {
                b.isSelected = true
            }
        }
        constrainBottomLine(selectedSegmentIndex, animated: animated)
        sendActions(for: .valueChanged)
    }

    fileprivate func constrainBottomLine(_ toIndex: Int, animated: Bool = true) {
        self.layoutIfNeeded()

        for (index, constraint) in self.underlineConstraints.enumerated() {
            if index != toIndex {
                constraint.priority = 250
            } else {
                constraint.priority = 750
            }
        }

        if animated {
            UIView.animate(withDuration: style.animationTime, animations: {
                self.layoutIfNeeded()
            })
        } else {
            self.layoutIfNeeded()
        }
    }
}
