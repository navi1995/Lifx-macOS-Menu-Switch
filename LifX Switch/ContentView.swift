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
			VStack{
				PowerSwitch(device: device, col: Color(hue: Double((device.color?.hueFraction ?? 1) * 360), saturation: Double((device.color?.saturationFraction ?? 1 * 100)), brightness: Double((device.color?.brightnessFraction ?? 1) * 100)))
			}
		}
	}
}

struct PowerSwitch: View {
	@ObservedObject var device: LifxDevice
	@State var col: Color
	//Color.white
		//Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
//	init(device: LifxDevice) {
//		print(device.color?.hue)
//		self.device = device
//		self.colour = Color(hue: Double(device.color?.hue ?? 1), saturation: Double(device.color?.saturation ?? 1), brightness: Double(device.color?.brightness ?? 1))
//	}
	
	var isOn: Binding<Bool> {
		Binding(get: {
			return self.device.powerOn == true
		}, set: {
			self.device.powerOn = $0
		})
	}
	
	var body: some View {
		return HStack {
			Text(device.label != nil ? (device.label ?? "") + (device.group ?? "") : device.ipAddress)
			Spacer()
			Toggle("", isOn: isOn)
				.toggleStyle(SwitchToggleStyle())
				.disabled(device.powerOn == nil)
		}
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity)
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
