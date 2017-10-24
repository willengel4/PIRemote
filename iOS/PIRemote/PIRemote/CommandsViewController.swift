//
//  CommandsViewController.swift
//  PIRemote
//
//  Created by Will Engel on 4/15/17.
//  Copyright © 2017 SnappyApps. All rights reserved.
//

import UIKit

class CommandsViewController  : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var tableView: UITableView!
    var devices : [Device]?
    var currentDevice = 0
    
    @IBOutlet weak var command: UITextField!
    @IBOutlet weak var nextState: UILabel!
    @IBOutlet weak var nextStateImage: UIImageView!
    var nextStateIndex = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        updateTransitionStateView()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        devices = SystemData().loadDevices()
        
        for dev in devices!
        {
            if dev.id == "-"
            {
                break
            }
            
            currentDevice += 1
        }
        
        if currentDevice >= devices!.count
        {
            print("ERROR")
        }
    }
    
    /* The number of rows */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return devices![currentDevice].commands.count
    }
    
    /* When a row is selected */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func updateTransitionStateView()
    {
        if devices![currentDevice].states.count > 0
        {
            nextState.text = devices![currentDevice].states[nextStateIndex].state
            nextStateImage.image = UIImage(named:  devices![currentDevice].states[nextStateIndex].color!)
        }
    }
    
    /* When a row is rendered? */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "CommandViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CommandViewCell
        
        let cmd = devices![currentDevice].commands[indexPath.row]
        
        cell.commandText.text = cmd.command
        cell.nextState.text = cmd.nextState!.state
        cell.nextStateColor.image = UIImage(named: cmd.nextState!.color!)
        
        return cell
    }
    
    @IBAction func upPressed(_ sender: Any)
    {
        nextStateIndex += 1
        
        if nextStateIndex >= devices![currentDevice].states.count
        {
            nextStateIndex = 0
        }
        
        updateTransitionStateView()
    }
    
    @IBAction func downPressed(_ sender: Any)
    {
        nextStateIndex -= 1
        
        if nextStateIndex < 0
        {
            nextStateIndex = devices![currentDevice].states.count - 1
        }
        
        updateTransitionStateView()
    }
    
    @IBAction func addCommand(_ sender: Any)
    {
        let cmd = Command(devID: devices![currentDevice].id!, command: command.text!, nextState: devices![currentDevice].states[nextStateIndex])
        
        devices![currentDevice].commands.append(cmd)
        
        tableView.reloadData()
        
        command.text = ""
    }
    
    @IBAction func backPressed(_ sender: Any)
    {
        SystemData().saveDevices(devices: devices!)
        self.performSegue(withIdentifier: "commandsDone", sender: nil)
    }
    
    
}
