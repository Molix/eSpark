//
//  BLEManager.swift
//  eSpark
//
//  Created by Ale MQ on 5/4/17.
//  Copyright © 2017 Ale MQ. All rights reserved.
//

import Foundation
import CoreBluetooth

final class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate{
    
    // Shared Instance
    static let shared = BLEManager()

    // Class variables
    dynamic var foundPeripherals = Array<CBPeripheral>()
    private var centralManager: CBCentralManager?

    private override init() {

        super.init()
        print("BLE Manager initialized")
    }
    
    func initCentralManager() {

        // Initialize CoreBluetooth Central Manager
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
    // CBCentralManager Methods
    func centralManagerDidUpdateState(_ central: CBCentralManager) {

        if (central.state == .poweredOn){
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
        else {
            // do something like alert the user that ble is not on
            print("BLE not available")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        foundPeripherals.append(peripheral)
        
        // Send Notification of new peripheral found
        NotificationCenter.default.post(name:eSparkNotifications.peripheralFound, object: nil, userInfo:nil)
    }
}
