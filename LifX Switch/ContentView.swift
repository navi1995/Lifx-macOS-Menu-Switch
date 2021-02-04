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
	@State var client: LifxLanClient
	
	var body: some View {
		Group {
			if lifx.devices.count == 0 {
				VStack {
					Text("No devices Found!")
					Text("Make sure you're connected to the same network.")
				}
				.padding()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.multilineTextAlignment(.center)
			} else {
				List(lifx.devices) { device in
					VStack {
						PowerSwitch(device: device, col: Color(device.color?.baseColor ?? NSColor(Color.white)))
					}
				}
			}
			Button("Refresh", action: {
				client.startRefreshing()
				
				//After 5 seconds, stop refreshing/updating.
				DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
					client.stopRefreshing()
				}
			}).padding()
		}
	}
}

struct PowerSwitch: View {
	@ObservedObject var device: LifxDevice
	@State var col: Color
	
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
			ColorPicker("", selection: Binding(
							get: { self.col },
							set: { (newValue) in
								let hsb = rgbToHsv(color: newValue)
								
								self.col = newValue
								self.device.color = HSBK(hue: hsb.h, saturation: hsb.s, brightness: hsb.v)
							}), supportsOpacity: false)
		}
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}

func rgbToHsv(color: Color) -> (h:Float, s:Float, v:Float){
	let r:Float = Float(color.cgColor?.components?[0] ?? 0)
	let g:Float = Float(color.cgColor?.components?[1] ?? 0)
	let b:Float = Float(color.cgColor?.components?[2] ?? 0)
	let maxi:Float = max(r, g, b)
	let mini:Float = min(r, g, b)
	
	//0-1
	var h:Float = 0
	var s:Float = 0
	let v:Float = maxi
	
	if maxi == mini {
		h = 0.0
	} else if maxi == r && g >= b {
		h = 60 * (g - b) / (maxi - mini)
	} else if maxi == r && g < b {
		h = 60 * (g - b) / (maxi - mini) + 360
	} else if maxi == g {
		h = 60 * (b - r) / (maxi - mini) + 120
	} else if maxi == b {
		h = 60 * (r - g) / (maxi - mini) + 240
	}
	
	h = h / 360
	
	if maxi == 0 {
		s = 0
	} else {
		s = (maxi - mini) / maxi
	}
	
	return (h, s, v)
}
