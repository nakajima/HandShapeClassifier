# import HandShape

This library allows for recognition of certain hand shapes when using visionOS. It
currently supports `fist`, `openPalm` and `holding([Finger])` which contains the currently
held up fingers.

The detection method is naive and could be improved. Other shapes could be added as well.
Still, hope you find it useful.

### Usage:

```swift
for await update in handTracker.anchorUpdates {
```

