import ARKit
import RealityKit

struct Classifier {
	let skeleton: HandSkeleton

	var classification: HandShape? {
		let wrist = point(.wrist)

		let holding = HandShape.Finger.allCases.map { ($0, tipIsClosed($0.tip, from: wrist)) }

		if holding.allSatisfy({ $0.1 }) {
			return .fist
		}

		if holding.allSatisfy({ !$0.1 }) {
			return .openPalm
		}

		return .holdingUp(holding.filter { !$0.1 }.map(\.0))
	}

	func point(_ joint: HandSkeleton.JointName) -> SIMD3<Float> {
		return Transform(matrix: skeleton.joint(joint).anchorFromJointTransform).translation
	}

	// These values are mapped to my hand. Should probably make it more flexible
	func tipIsClosed(_ joint: HandSkeleton.JointName, from origin: SIMD3<Float>) -> Bool {
		switch joint {
		case .thumbTip:
			return distance(origin, point(joint)) < 0.12
		case .littleFingerTip:
			return distance(origin, point(joint)) < 0.08
		case .indexFingerTip, .middleFingerTip, .ringFingerTip:
			return distance(origin, point(joint)) < 0.1
		default:
			return false
		}
	}
}

public enum HandShape: Equatable {
	public enum Finger: String, CaseIterable {
		case thumb, index, middle, ring, little

		var tip: HandSkeleton.JointName {
			switch self {
			case .thumb:
				return .thumbTip
			case .index:
				return .indexFingerTip
			case .middle:
				return .middleFingerTip
			case .ring:
				return .ringFingerTip
			case .little:
				return .littleFingerTip
			}
		}
	}

	case fist, openPalm, holdingUp([Finger])

	public static func classify(_ skeleton: HandSkeleton) -> Self? {
		Classifier(skeleton: skeleton).classification
	}

	var description: String {
		switch self {
		case .fist:
			"fist"
		case .openPalm:
			"openPalm"
		case let .holdingUp(fingers):
			"holdingUp \(fingers.map(\.rawValue).joined(separator: ", "))"
		}
	}
}
