//
//  ViewController.swift
//  eSpark
//
//  Created by Ale MQ on 5/3/17.
//  Copyright © 2017 Ale MQ. All rights reserved.
//

import UIKit
import CoreBluetooth


class ViewController: UIViewController {

    var peripherals = Array<CBPeripheral>()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Observe the update of Peripheral's value
        // Note: we don't use KVO (but Notificacion Center) because we don't observe a value change, but an array growth
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.newPeripheralWasFound), name: eSparkNotifications.peripheralFound, object: nil)
        
        // Initialize CoreBluetooth Central Manager
        BLEManager.shared.initCentralManager()
        
        // Register the tebleViewCell for reuse
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newPeripheralWasFound(notification: Notification) {
        
        // Update Peripherals array and table
        peripherals = BLEManager.shared.foundPeripherals
        tableView.reloadData()
    }
    
    deinit {

        // Stop listening notification
        NotificationCenter.default.removeObserver(self, name: eSparkNotifications.peripheralFound, object: nil);
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as UITableViewCell
        
        let peripheral = peripherals[indexPath.row]
        cell.textLabel?.text = peripheral.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
}
