//
//  ViewModel.swift
//  HandShapeExampleApp
//
//  Created by Pat Nakajima on 2/19/24.
//

import Foundation
import Observation
import ARKit
import HandShapeClassifier

@Observable class ViewModel {
	// Gets updated with the shape
	var leftShape: HandShape?
	var rightSHape: HandShape?

	// Did something go wrong?
	var error: String?

	let session = ARKitSession()
	let handTracker = HandTrackingProvider()

	var shapeLabel: String {
		var label = "Left: "

		switch leftShape {
		case .fist:
			label += "Fist"
		case .openPalm:
			label += "Open Palm"
		case .holdingUp(let fingers):
			label += "Holding up \(fingers.map(\.rawValue).joined(separator: ", "))"
		case nil:
			label += "No shape"
		}

		label += "\nRight: "

		switch rightSHape {
		case .fist:
			label += "Fist"
		case .openPalm:
			label += "Open Palm"
		case .holdingUp(let fingers):
			label += "Holding up \(fingers.map(\.rawValue).joined(separator: ", "))"
		case nil:
			label += "No shape"
		}

		return label
	}

	func start() async {
		_ = await session.requestAuthorization(for: [.handTracking])

		do {
			try await session.run([handTracker])
		} catch {
			await MainActor.run {
				self.error = error.localizedDescription
			}
		}

		for await update in handTracker.anchorUpdates {
			guard let skeleton = update.anchor.handSkeleton else {
				continue
			}

			if let shape = HandShape.classify(skeleton) {
				await MainActor.run {
					if update.anchor.chirality == .left {
						self.leftShape = shape
					} else {
						self.rightSHape = shape
					}
				}
			}
		}
	}
}
