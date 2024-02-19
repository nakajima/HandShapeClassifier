import RealityKit
import ARKit

struct Classifier {
	let skeleton: HandSkeleton

	var classification: HandShape? {
		let wrist = point(.wrist)

		if tipIsClosed(.thumbTip, from: wrist),
			 tipIsClosed(.indexFingerTip, from: wrist),
			 tipIsClosed(.middleFingerTip, from: wrist),
			 tipIsClosed(.ringFingerTip, from: wrist),
			 tipIsClosed(.littleFingerTip, from: wrist) {
			return .fist
		}

		if !tipIsClosed(.thumbTip, from: wrist),
			 !tipIsClosed(.indexFingerTip, from: wrist),
			 !tipIsClosed(.middleFingerTip, from: wrist),
			 !tipIsClosed(.ringFingerTip, from: wrist),
			 !tipIsClosed(.littleFingerTip, from: wrist) {
			return .openPalm
		}

		if !tipIsClosed(.thumbTip, from: wrist),
			 tipIsClosed(.indexFingerTip, from: wrist),
			 tipIsClosed(.middleFingerTip, from: wrist),
			 tipIsClosed(.ringFingerTip, from: wrist),
			 tipIsClosed(.littleFingerTip, from: wrist) {
			return .thumbUp
		}

		if tipIsClosed(.thumbTip, from: wrist),
			 !tipIsClosed(.indexFingerTip, from: wrist),
			 tipIsClosed(.middleFingerTip, from: wrist),
			 tipIsClosed(.ringFingerTip, from: wrist),
			 tipIsClosed(.littleFingerTip, from: wrist) {
			return .indexUp
		}

		if tipIsClosed(.thumbTip, from: wrist),
			 tipIsClosed(.indexFingerTip, from: wrist),
			 !tipIsClosed(.middleFingerTip, from: wrist),
			 tipIsClosed(.ringFingerTip, from: wrist),
			 tipIsClosed(.littleFingerTip, from: wrist) {
			return .middleUp
		}

		if tipIsClosed(.thumbTip, from: wrist),
			 tipIsClosed(.indexFingerTip, from: wrist),
			 tipIsClosed(.middleFingerTip, from: wrist),
			 !tipIsClosed(.ringFingerTip, from: wrist),
			 tipIsClosed(.littleFingerTip, from: wrist) {
			return .ringUp
		}

		if tipIsClosed(.thumbTip, from: wrist),
			 tipIsClosed(.indexFingerTip, from: wrist),
			 tipIsClosed(.middleFingerTip, from: wrist),
			 tipIsClosed(.ringFingerTip, from: wrist),
			 !tipIsClosed(.littleFingerTip, from: wrist) {
			return .littleUp
		}

		return nil
	}

	func point(_ joint: HandSkeleton.JointName) -> SIMD3<Float> {
		return Transform(matrix: skeleton.joint(joint).anchorFromJointTransform).translation
	}

	func tipIsClosed(_ joint: HandSkeleton.JointName, from origin: SIMD3<Float>) -> Bool {
		switch joint {
		case .thumbTip:
			return distance(origin, point(joint)) < 0.12
		case .indexFingerTip, .middleFingerTip, .ringFingerTip, .littleFingerTip:
			return distance(origin, point(joint)) < 0.1
		default:
			return false
		}
	}
}

public enum HandShape: String {
	case fist, openPalm, thumbUp, indexUp, middleUp, ringUp, littleUp

	public static func classify(_ skeleton: HandSkeleton) -> Self? {
		Classifier(skeleton: skeleton).classification
	}

	var description: String {
		rawValue
	}
}
