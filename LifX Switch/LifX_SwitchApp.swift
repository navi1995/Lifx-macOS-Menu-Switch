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
	@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
	var body: some Scene {
        Settings {
			EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
	var popover = NSPopover.init()
	var statusBarItem: NSStatusItem?
	let client = try! LifxLanClient()
	
	override init() {
		client.discover()
	}
	
	func applicationDidFinishLaunching(_ notification: Notification) {
		
		let contentView = ContentView(client: client)
			.environmentObject(client.state)
		
		popover.behavior = .transient
		popover.animates = false
		popover.contentViewController = NSViewController()
		popover.contentViewController?.view = NSHostingView(rootView: contentView)
		popover.contentViewController?.preferredContentSize = CGSize(width: 348, height: 400)
		statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
		//statusBarItem?.button?.title = "􀛭"
		statusBarItem?.button?.image = NSImage(systemSymbolName: "lightbulb", accessibilityDescription: "Lifx Bar")
		statusBarItem?.button?.action = #selector(AppDelegate.togglePopover(_:))
	}
	
	@objc func showPopover(_ sender: AnyObject?) {
		if let button = statusBarItem?.button {
			popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
		}
	}
	
	@objc func closePopover(_ sender: AnyObject?) {
		popover.performClose(sender)
	}
	
	@objc func togglePopover(_ sender: AnyObject?) {
		if popover.isShown {
			closePopover(sender)
		} else {
			showPopover(sender)
		}
	}
}
