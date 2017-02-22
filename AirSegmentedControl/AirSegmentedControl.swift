//
//  AirSegmentedControl.swift
//  AirSegmentedControl
//
//  Created by Steven Thompson on 2017-02-17.
//  Copyright © 2017 airg. All rights reserved.
//

import UIKit

/// Custom UIControl subclass
@IBDesignable
@objc(AirSegmentedControl) open class AirSegmentedControl: UIControl {
    public typealias Segment = String

    //MARK: IBInspectables
    /// Convenience for `@IBInspectable` settings segment titles
    @IBInspectable @objc open var commaSeparatedSegments: String = "" {
        didSet {
            let segs = commaSeparatedSegments.components(separatedBy: ",")
            segments = segs
        }
    }

    /// Controls how quickly the underline moves between sections. `valueChanged` is always sent immediately.
    @IBInspectable @objc open var animationTime: Double = 0.2

    /// When `true`, only sends a `valueChanged` when the value changes to something different.
    @IBInspectable @objc open var shouldIgnoreDuplicateInputs: Bool = true

    /// The color of the underline
    @IBInspectable @objc open var underlineColor: UIColor = .darkGray {
        didSet {
            underline.backgroundColor = underlineColor
        }
    }

    /// The height of the underline
    @IBInspectable @objc open var underlineHeight: Int = 2 {
        didSet {
            setupView()
        }
    }

    /// The color of the segment text when selected
    @IBInspectable @objc open var textColorSelected: UIColor = .black {
        didSet {
            setupView()
        }
    }

    /// The text color of all unselected segments
    @IBInspectable @objc open var textColorUnselected: UIColor = .darkGray {
        didSet {
            setupView()
        }
    }

    /// Font
    @IBInspectable @objc open var textFont: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet {
            setupView()
        }
    }

    /// Whether to show a bottom border
    @IBInspectable @objc open var bottomBorderVisible: Bool = false {
        didSet {
            setupView()
        }
    }

    /// The color of the bottom border, if it's visible
    @IBInspectable @objc open var bottomBorderColor: UIColor = .lightGray {
        didSet {
            bottomBorder.backgroundColor = bottomBorderColor
        }
    }

    /// The height of the bottom border
    @IBInspectable @objc open var bottomBorderHeight: Int = 1 {
        didSet {
            setupView()
        }
    }

    //MARK:- Properties
    /// Array of `Segment` which are being displayed
    open fileprivate(set) var segments: [String] = [] {
        didSet {
            setupView()
        }
    }

    /// Get the currently selected segment index
    open fileprivate(set) var selectedSegmentIndex: Int = 0

    fileprivate let underline: UIView = UIView()
    fileprivate var underlineConstraints: [NSLayoutConstraint] = []

    fileprivate let bottomBorder: UIView = UIView()

    //MARK:- Lifecycle
    override open func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupView()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    //MARK:- Public Interface

    /// Configure the control with provided segments and style
    ///
    /// - Parameters:
    ///   - segments: Array of segments to display
    ///   - style: Optional style configuration, if `nil`
    open func configure(with segments: [Segment]) {
        self.segments = segments

        setupView()
    }

    /// Select an index, sending a `valueChanged` event.
    ///
    /// - Parameters:
    ///   - index: Index to select
    ///   - animated: Should the selection be animated,
    open func select(at index: Int, animated: Bool = true) {
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

    //MARK:- Private Methods
    fileprivate func setupView() {
        for view in subviews {
            view.removeFromSuperview()
        }

        underlineConstraints = []

        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.backgroundColor = underlineColor

        addSubview(underline)

        if bottomBorderVisible {
            bottomBorder.translatesAutoresizingMaskIntoConstraints = false
            bottomBorder.backgroundColor = bottomBorderColor
            addSubview(bottomBorder)

            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[border]|", options: [], metrics: nil, views: ["border": bottomBorder]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[border(borderHeight)]|", options: [], metrics: ["borderHeight": bottomBorderHeight], views: ["border": bottomBorder]))

            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(height)]-(borderHeight)-|", options: [], metrics: ["height": underlineHeight, "borderHeight": bottomBorderHeight], views: ["line": underline]))
        } else {
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(height)]|", options: [], metrics: ["height": underlineHeight], views: ["line": underline]))
        }

        var previousButton: UIButton?

        for (index, title) in segments.enumerated() {
            let button = UIButton()
            button.setAttributedTitle(NSAttributedString(string: title, attributes: [NSFontAttributeName: textFont, NSForegroundColorAttributeName: textColorUnselected]), for: .normal)
            button.setAttributedTitle(NSAttributedString(string: title, attributes: [NSFontAttributeName: textFont, NSForegroundColorAttributeName: textColorSelected]), for: .selected)
            button.setAttributedTitle(NSAttributedString(string: title, attributes: [NSFontAttributeName: textFont, NSForegroundColorAttributeName: textColorSelected]), for: .highlighted)
            button.tintColor = textColorUnselected
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = index
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            addSubview(button)

            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[b]|", options: [], metrics: nil, views: ["b": button]))

            switch index {
            case let n where n == 0 && segments.count == 1:
                addConstraint(NSLayoutConstraint(item: underline, attribute: .width, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1, constant: 0))

                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[b]|", options: [], metrics: nil, views: ["b": button]))

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
        if shouldIgnoreDuplicateInputs && selectedSegmentIndex == sender.tag {
            return
        }
        select(at: sender.tag, animated: true)
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
            UIView.animate(withDuration: animationTime, animations: {
                self.layoutIfNeeded()
            })
        } else {
            self.layoutIfNeeded()
        }
    }
}
