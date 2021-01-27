//
//  ContentView.swift
//  LifX Switch
//
//  Created by Navi Jador on 27/01/21.
//

import SwiftUI
import Lifx

struct ContentView: View {
	@EnvironmentObject var lifx: LifxState
	
	//For every device, append to a group using device.group
	//Location = Home
	//Group = Bedroom
	var body: some View {
		List(lifx.devices) { device in
			PowerSwitch(device: device)
		}
	}
}

struct PowerSwitch: View {
	@ObservedObject var device: LifxDevice
	
	var isOn: Binding<Bool> {
		Binding(get: {
			return self.device.powerOn == true
		}, set: {
			self.device.powerOn = $0
		})
	}
	
	var body: some View {
		return Toggle(isOn: isOn) {
			Text(device.label != nil ? (device.label ?? "") + (device.group ?? "") : device.ipAddress)
		}
		.toggleStyle(SwitchToggleStyle())
		.disabled(device.powerOn == nil)
	}
}

struct ContentView_Previews: PreviewProvider {
	let client = try! LifxLanClient()
	
	init() {
		client.startRefreshing()
	}
	
    static var previews: some View {
        ContentView()
    }
}
