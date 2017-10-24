//
//  StatesViewController.swift
//  PIRemote
//
//  Created by Will Engel on 4/15/17.
//  Copyright © 2017 SnappyApps. All rights reserved.
//

import UIKit

class StatesViewController  : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var tableView: UITableView!
    var devices = [Device]()
    
    @IBOutlet weak var stateText: UITextField!
    @IBOutlet weak var colorPicker: UIImageView!
    var colors = ["rsz_red.png", "rsz_green.png", "rsz_blue.png"]
    var currColor = 0
    var currentDevice = 0
        
    @IBOutlet weak var initStateColor: UIImageView!
    @IBOutlet weak var initStateLabel: UILabel!
    var initStateIndex = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        if devices[currentDevice].state != nil
        {
            initStateLabel.text = devices[currentDevice].state!.state!
            initStateColor.image = UIImage(named: devices[currentDevice].state!.color!)
        }

    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        devices = SystemData().loadDevices()
        
        for dev in devices
        {
            if dev.id == "-"
            {
                break
            }
            
            currentDevice += 1
        }
        
        if currentDevice == devices.count
        {
            print("error, no - token")
        }
    }
    
    /* The number of rows */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return devices[currentDevice].states.count
    }
    
    /* When a row is selected */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    /* When a row is rendered? */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "StateViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! StateViewCell
        
        let state = devices[currentDevice].states[indexPath.row]
        
        cell.stateText.text = state.state!
        cell.stateColor.image = UIImage(named: state.color!)
        
        return cell
    }
    
    @IBAction func colorUpPressed(_ sender: Any)
    {
        currColor += 1
        
        if currColor >= colors.count
        {
            currColor = 0
        }
        
        colorPicker.image = UIImage(named: colors[currColor])
    }
    
    @IBAction func colorDownPressed(_ sender: Any)
    {
        currColor -= 1
        
        if currColor < 0
        {
            currColor = colors.count - 1
        }
        
        colorPicker.image = UIImage(named: colors[currColor])
    }
 
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    @IBAction func addState(_ sender: Any)
    {
        let id = String(Character(UnicodeScalar(devices[currentDevice].states.count + 65)!))
        
        devices[currentDevice].states.append(State(id: id, state: stateText.text!, color: colors[currColor]))
        stateText.text = ""

        
        if devices[currentDevice].states.count == 1
        {
            devices[currentDevice].state = devices[currentDevice].states[0]
            initStateLabel.text = devices[currentDevice].state!.state!
            initStateColor.image = UIImage(named: devices[currentDevice].state!.color!)
        }
 
        
        tableView.reloadData()
    }
    
    @IBAction func initUpPressed(_ sender: Any)
    {
        initStateIndex += 1
        
        if initStateIndex >= devices[currentDevice].states.count
        {
            initStateIndex = 0
        }
        
        
        devices[currentDevice].state = devices[currentDevice].states[initStateIndex]
        initStateLabel.text = devices[currentDevice].state!.state!
        initStateColor.image = UIImage(named: devices[currentDevice].state!.color!)
    }
    
    @IBAction func initDownPressed(_ sender: Any)
    {
        initStateIndex -= 1
        
        if initStateIndex < 0
        {
            initStateIndex = devices[currentDevice].states.count - 1
        }
        
        devices[currentDevice].state = devices[currentDevice].states[initStateIndex]
        initStateLabel.text = devices[currentDevice].state!.state!
        initStateColor.image = UIImage(named: devices[currentDevice].state!.color!)
    }
    
    @IBAction func backPressed(_ sender: Any)
    {
        SystemData().saveDevices(devices: devices)
        self.performSegue(withIdentifier: "statesDone", sender: nil)
    }
    
}
