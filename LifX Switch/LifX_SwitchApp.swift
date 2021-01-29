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
		
		let contentView = ContentView()
			.environmentObject(client.state)
		
		// Set the SwiftUI's ContentView to the Popover's ContentViewController
		popover.behavior = .transient // !!! - This does not seem to work in SwiftUI2.0 or macOS BigSur yet
		popover.animates = false
		popover.contentViewController = NSViewController()
		popover.contentViewController?.view = NSHostingView(rootView: contentView)
		statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
		statusBarItem?.button?.title = "Test"
		statusBarItem?.button?.action = #selector(AppDelegate.togglePopover(_:))
	}
	@objc func showPopover(_ sender: AnyObject?) {
		if let button = statusBarItem?.button {
			popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
			//            !!! - displays the popover window with an offset in x in macOS BigSur.
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
