//
//  LifX_SwitchApp.swift
//  LifX Switch
//
//  Created by Navi Jador on 27/01/21.
//

import SwiftUI
import Lifx

@main
struct LifX_SwitchApp: App {
	let client = try! LifxLanClient()
	
	init() {
		client.startRefreshing()
	}
	
    var body: some Scene {
        WindowGroup {
			ContentView()
				.environmentObject(client.state)
        }
    }
}
