# `import HandShapeClassifier`

This library allows for recognition of certain hand shapes when using visionOS. It
currently supports `fist`, `openPalm` and `holding([Finger])` which contains the currently
held up fingers.

The detection method is naive and could be improved. Other shapes could be added as well.
Still, hope you find it useful.

![gif demo of the example app](https://github.com/nakajima/HandShapeClassifier/blob/main/handdemo.gif?raw=true)

### Usage:

```swift
// Start tracking hand movements
for await update in handTracker.anchorUpdates {
  // Get a hand skeleton
  guard let skeleton = update.anchor.handSkeleton else {
    continue
  }

  // Pass the skeleton to HandShape.classify
  if let shape = HandShape.classify(skeleton) {
    // Print out which hand and which shape
    print("\(update.anchor.chirality) is \(shape)")
  }
}
```
