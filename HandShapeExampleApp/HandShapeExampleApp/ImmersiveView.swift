//
//  ImmersiveView.swift
//  HandShapeExampleApp
//
//  Created by Pat Nakajima on 2/19/24.
//

import RealityKit
import SwiftUI

struct ImmersiveView: View {
	@Environment(ViewModel.self) var viewModel

	var body: some View {
		RealityView { content in
			var material = PhysicallyBasedMaterial()
			material.baseColor = .init(tint: .white)

			let entity = ModelEntity(
				mesh: .generateText(
					"Make shapes with your hands.",
					extrusionDepth: 0.01,
					font: .systemFont(ofSize: 0.1)
				),
				materials: [material]
			)

			entity.position = .init(
				x: entity.visualBounds(relativeTo: nil).extents.x / -2,
				y: 0.6,
				z: -1
			)

			content.add(entity)
		}
		.task {
			await viewModel.start()
		}
	}
}

#Preview {
	ImmersiveView()
		.previewLayout(.sizeThatFits)
}
