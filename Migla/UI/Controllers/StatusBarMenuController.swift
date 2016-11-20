//
//  StatusBarMenuController.swift
//  Migla
//
//  Created by Giedrius Stanevicius on 2016-07-26.
//  Copyright © 2016 Migla. All rights reserved.
//

import Foundation
import AppKit

public class StatusBarMenuController: NSObject, NSMenuDelegate {
    
    @IBOutlet weak var statusBarMenu: NSMenu!
    @IBOutlet weak var availableDevicesItem: NSMenuItem!
    
    public var deviceDataSource: DeviceDataSource?
    
    let statusBarItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    
    var preferencesWindowController: PreferencesWindowController?
    
    override public func awakeFromNib() {
        let statusBarIcon = #imageLiteral(resourceName: "statusBarIcon")
        statusBarIcon.isTemplate = true
        
        self.statusBarItem.image = statusBarIcon
        self.statusBarItem.menu = statusBarMenu
    }
    
    
    
    @IBAction func quit(_ sender: AnyObject?) {
        NSApp.terminate(sender)
    }
    
    @IBAction func openPreferences(_ sender: AnyObject?) {
        if self.preferencesWindowController == nil {
            self.preferencesWindowController = PreferencesWindowController.loadController()
            self.preferencesWindowController!.deviceDataSource = self.deviceDataSource
        }
        self.preferencesWindowController?.showWindow(nil)
    }
    
    
    // MARK: NSMenuDelegate
    
    public func menuNeedsUpdate(_ menu: NSMenu) {
        if menu == self.statusBarMenu {
            self.refreshMenuDeviceList()
        }
    }
    
    
    
    func refreshDeviceLists() {
        self.preferencesWindowController?.refreshDeviceList()
    }
    
    func refreshMenuDeviceList() {
        // remove old device items
        
        var item = self.statusBarMenu.item(withTag: InterfaceElementTags.availableDeviceMenuItem.rawValue)
        while item != nil {
            self.statusBarMenu.removeItem(item!)
            item = self.statusBarMenu.item(withTag: InterfaceElementTags.availableDeviceMenuItem.rawValue)
        }
        
        // add new device items
        
        let devices = self.deviceDataSource?.pairedDevices ?? []
        guard devices.count > 0 else { return }
        
        var index = self.statusBarMenu.index(of: self.availableDevicesItem)
        assert(index != -1, "availableDevicesItem expected to be item of statusBarMenu")
        for device in devices {
            let item = NSMenuItem(title: device.name, action: nil, keyEquivalent: "")
            item.tag = InterfaceElementTags.availableDeviceMenuItem.rawValue
            item.submenu = DeviceMenu(device: device)
            index += 1
            self.statusBarMenu.insertItem(item, at: index)
        }
    }
}
