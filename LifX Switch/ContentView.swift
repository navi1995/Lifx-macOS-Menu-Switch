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
	//var dict = [String: Array<LifxDevice>]()
	
	//For every device, append to a group using device.group
	var body: some View {
		return List(lifx.devices) { device in
			VStack{
				PowerSwitch(device: device, col: Color(device.color?.baseColor ?? NSColor(Color.white)))
			}
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
							}))
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

func rgbToHsv(color: Color) -> (h:Float, s:Float, v:Float){
	let r:Float = Float(color.cgColor?.components?[0] ?? 0)
	let g:Float = Float(color.cgColor?.components?[1] ?? 0)
	let b:Float = Float(color.cgColor?.components?[2] ?? 0)
	let Max:Float = max(r, g, b)
	let Min:Float = min(r, g, b)
	
	//0-1
	var h:Float = 0
	var s:Float = 0
	let v:Float = Max
	
	if Max == Min {
		h = 0.0
	} else if Max == r && g >= b {
		h = 60 * (g-b)/(Max-Min)
	} else if Max == r && g < b {
		h = 60 * (g-b)/(Max-Min) + 360
	} else if Max == g {
		h = 60 * (b-r)/(Max-Min) + 120
	} else if Max == b {
		h = 60 * (r-g)/(Max-Min) + 240
	}
	
	h = h/360
	
	if Max == 0 {
		s = 0
	} else {
		s = (Max - Min)/Max
	}
	
	return (h, s, v)
}
