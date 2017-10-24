//
//  DevicesViewController.swift
//  PIRemote
//
//  Created by Will Engel on 4/15/17.
//  Copyright © 2017 SnappyApps. All rights reserved.
//                                                                                        

import UIKit

class DevicesViewController  : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var tableView: UITableView!
    var devices : [Device]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        devices = SystemData().loadDevices()

        super.init(coder: aDecoder)
    }
    
    /* The number of rows */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return devices.count
    }
    
    /* When a row is selected */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        SystemData().writeTextToFile("\(indexPath.row)", fileName: "controlDevice.txt")
        
        self.performSegue(withIdentifier: "controlDev", sender: nil)
    }
    
    /* When a row is rendered? */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "DeviceViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DeviceViewCell
    
        let dev = devices[indexPath.row]
        
        if dev.id != "-"
        {
            cell.deviceName.text = dev.name!
            cell.deviceState.text = dev.state!.state!
            cell.deviceIcon.image = UIImage(named: dev.icon!)
            cell.stateColor.image = UIImage(named: dev.state!.color!)
        }
        
        return cell
    }
    
    
    @IBAction func addNewDevice(_ sender: Any)
    {
        let newDevice = Device(id: "-", name: nil, type: nil, state: nil, icon: nil, password: nil, accessToken: nil)
        devices.append(newDevice)
        SystemData().saveDevices(devices: devices)
        self.performSegue(withIdentifier: "regDev", sender: nil)
    }
}
