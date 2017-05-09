//
//  BLEManager.swift
//  eSpark
//
//  Created by Ale MQ on 5/4/17.
//  Copyright © 2017 Ale MQ. All rights reserved.
//

import Foundation
import CoreBluetooth


// Services and Characteristics
let BS_SCRATCH_UUID = CBUUID(string: "96A12A2F-5302-4003-82CB-985BCDCCB3ED")
let BS_SERVICE_UUID = CBUUID(string: "4253")



final class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate{
    
    // Shared Instance
    static let shared = BLEManager()

    // Class variables
    private var centralManager: CBCentralManager?

    var foundPeripherals = Array<CBPeripheral>()
    private var foundCharacteristics = Array<CBCharacteristic>()

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

        if !foundPeripherals.contains(peripheral) {
            foundPeripherals.append(peripheral)
        
            centralManager?.connect(peripheral, options: nil)

            // Send Notification of new peripheral found
            NotificationCenter.default.post(name:eSparkNotifications.peripheralFound, object: nil, userInfo:nil)
        }        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {

        print("Peripheral Connected: \(String(describing: peripheral.name))")
        
        // Become peripheral's delegate
        peripheral.delegate = self;

        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {

        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }
    
    // CBPeripheral Methods
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        for service in peripheral.services! {
            let thisService = service as CBService
            
            if service.uuid == BS_SERVICE_UUID {
                peripheral.discoverCharacteristics(nil, for: thisService)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        foundCharacteristics = service.characteristics!
        
        print("Found characteristics:")
        for characteristic in foundCharacteristics {
            
            print("\(characteristic)")
        }
    }
}
