//: Playground - noun: a place where people can play

import UIKit
@testable import AirSegmentedControl
import PlaygroundSupport

var style = AirSegmentedControlStyle()
style.animationTime = 0.2

let control = AirSegmentedControl(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
control.configure(with: ["One", "Two", "Three"],
                  style: style)

PlaygroundPage.current.liveView = control
