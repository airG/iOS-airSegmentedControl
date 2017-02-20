A UIControl subclass that draws itself based on the number of segments provided.

![example](AirSegmentedControlExample.gif)

To get `IBDesignable` and `IBInspectable` to work in Interface Builder, add the [InspectableAirSegmentedControl file](http://gitlab.airg.us/airg-unit/AirSegmentedControl/blob/af6688730ff9bc60c81ba901f5ef036cead6784a/AirSegmentedControl/InspectableAirSegmentedControl.swift) to your project and use the `InspectableAirSegmentedControl` subclass.

**Installation**

Using Carthage, add this line to your Cartfile:

`git "git@gitlab.airg.com:airg-unit/AirSegmentedControl.git"`

Then run:

`carthage update --platform iOS --no-use-binaries` OR

`carthage update AirSegmentedControl --platform iOS --no-use-binaries`