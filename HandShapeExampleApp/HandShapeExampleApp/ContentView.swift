//
//  ContentView.swift
//  HandShapeExampleApp
//
//  Created by Pat Nakajima on 2/19/24.
//

import RealityKit
import SwiftUI

struct ContentView: View {
	@State private var showImmersiveSpace = false
	@State private var immersiveSpaceIsShown = false

	@Environment(ViewModel.self) var viewModel

	@Environment(\.openImmersiveSpace) var openImmersiveSpace
	@Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

	var body: some View {
		VStack(alignment: .center) {
			if immersiveSpaceIsShown {
				Text(viewModel.shapeLabel)
					.font(.largeTitle)
					.animation(.bouncy, value: viewModel.shapeLabel)
				Button("Hide Immersive Space") {
					Task {
						await dismissImmersiveSpace()
					}
				}
			} else {
				Button("Open Immersive Space") {
					Task {
						await openImmersiveSpace(id: "ImmersiveSpace")
					}
				}
			}
		}
		.padding()
		.onAppear {
			self.showImmersiveSpace = true
		}
		.onChange(of: showImmersiveSpace) { _, newValue in
			Task {
				if newValue {
					switch await openImmersiveSpace(id: "ImmersiveSpace") {
					case .opened:
						immersiveSpaceIsShown = true
					case .error, .userCancelled:
						fallthrough
					@unknown default:
						immersiveSpaceIsShown = false
						showImmersiveSpace = false
					}
				} else if immersiveSpaceIsShown {
					await dismissImmersiveSpace()
					immersiveSpaceIsShown = false
				}
			}
		}
	}
}

#Preview(windowStyle: .automatic) {
	ContentView()
}
