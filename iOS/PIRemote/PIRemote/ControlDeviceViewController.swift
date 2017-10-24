//
//  ControlDeviceViewController.swift
//  PIRemote
//
//  Created by Will Engel on 4/16/17.
//  Copyright © 2017 SnappyApps. All rights reserved.
//

import UIKit

class ControlDeviceViewController  : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var tableView: UITableView!
    var devices : [Device]?
    var selectedDevice = 0
    @IBOutlet weak var deviceTitle: UILabel!
    @IBOutlet weak var currentState: UILabel!
    @IBOutlet weak var currentStateImage: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        updateViewStuff()
    }
    
    func updateViewStuff()
    {
        deviceTitle.text = "\(devices![selectedDevice].name!) : \(devices![selectedDevice].type!)"
        currentState.text = devices![selectedDevice].state!.state!
        currentStateImage.image = UIImage(named: devices![selectedDevice].state!.color!)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        devices = SystemData().loadDevices()
        selectedDevice = Int(SystemData().loadInText("controlDevice.txt")!)!
        
        print(selectedDevice)
    }
    
    /* The number of rows */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return devices![selectedDevice].commands.count
    }
    
    func checkDevState()
    {
        let dat = devices![selectedDevice].accessToken!
        
        var urlStr = "http://108.161.133.186/pi/get_dev_state.php?dat=\(dat)"
        
        urlStr = urlStr.replacingOccurrences(of: " ", with: "%20")
        
        let url = URL(string: urlStr)
        
        /* Create the request */
        let request = URLRequest(url: url!)
        
        /* Make the request, get the response */
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main)
        {(response, data, error) in
            
            /* If there was an error */
            if(error != nil)
            {
                print("Error retrieving device data")
            }
            
            /* If there was no error */
            else
            {
                /* Get the response */
                let responseString = NSMutableString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                
                var newString = ""
                var count = 0
                for x in responseString.characters
                {
                    if count > 0
                    {
                        newString += String(x)
                    }
                    
                    count += 1
                }
                
                for s in self.devices![self.selectedDevice].states
                {
                    if s.id! == newString
                    {
                        print("worked")
                        self.devices![self.selectedDevice].state = s
                        break
                    }
                }
                
                self.updateViewStuff()
                SystemData().saveDevices(devices: self.devices!)
            }
        }
    }
    
    func sendCommand(row: Int)
    {
        let cmd = devices![selectedDevice].commands[row]
        let dat = devices![selectedDevice].accessToken!
        let uat = SystemData().loadInText("accessToken.txt")!
        let c = cmd.command!
        let sid = cmd.nextState!.id!
        
        var urlStr = "http://108.161.133.186/pi/send_command.php?dat=\(dat)&uat=\(uat)&c=\(c)&sid=\(sid)"
        
        urlStr = urlStr.replacingOccurrences(of: " ", with: "%20")
        
        let url = URL(string: urlStr)
        
        /* Create the request */
        let request = URLRequest(url: url!)
        
        /* Make the request, get the response */
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main)
        {(response, data, error) in
            
            /* If there was an error */
            if(error != nil)
            {
                print("Error signing up user")
            }
                
                /* If there was no error */
            else
            {
                /* Get the response */
                let responseString = NSMutableString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                
                print(responseString)
                
                if(!responseString.contains("error"))
                {
                    self.checkDevState();
                }
            }
        }
        
    }
    
    /* When a row is selected */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //EXECUTE!!!
        
        sendCommand(row: indexPath.row)
    }
    
    /* When a row is rendered? */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "ControlViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ControlViewCell
        
        let cmd = devices![selectedDevice].commands[indexPath.row]
        
        cell.command.text = cmd.command
        cell.nextState.text = cmd.nextState!.state
        cell.nextStateColor.image = UIImage(named: cmd.nextState!.color!)
        
        return cell
    }
}

