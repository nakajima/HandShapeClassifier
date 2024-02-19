//
//  HandShapeExampleAppApp.swift
//  HandShapeExampleApp
//
//  Created by Pat Nakajima on 2/19/24.
//

import SwiftUI

@main
struct HandShapeExampleApp: App {
	@State var viewModel = ViewModel()

	@State var immersionStyle: ImmersionStyle = .progressive

	var body: some Scene {
		WindowGroup {
			ContentView()
				.environment(viewModel)
		}

		ImmersiveSpace(id: "ImmersiveSpace") {
			ImmersiveView()
		}
		.environment(viewModel)
		.immersionStyle(selection: $immersionStyle, in: .progressive, .mixed, .full)
	}
}
