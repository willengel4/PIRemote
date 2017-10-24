//
//  RegisterDeviceViewController.swift
//  PIRemote
//
//  Created by Will Engel on 4/15/17.
//  Copyright © 2017 SnappyApps. All rights reserved.
//

import UIKit

class RegisterDeviceViewController : UIViewController
{
    
    @IBOutlet weak var defaultOutline: UIImageView!
    @IBOutlet weak var gameOutline: UIImageView!
    @IBOutlet weak var robotOutline: UIImageView!
    @IBOutlet weak var carOutline: UIImageView!
    @IBOutlet weak var laptopOutline: UIImageView!
    @IBOutlet weak var lightOutline: UIImageView!
    
    @IBOutlet weak var laptopButton: UIButton!
    @IBOutlet weak var defaultButton: UIButton!
    @IBOutlet weak var lightButton: UIButton!
    @IBOutlet weak var robotButton: UIButton!
    @IBOutlet weak var gameButton: UIButton!
    @IBOutlet weak var carButton: UIButton!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var type: UITextField!
    
    var currentIcon = "default.png"
    
    var devices : [Device]?
    var currentDevice = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        devices = SystemData().loadDevices()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        for dev in devices!
        {
            if dev.id == "-"
            {
                break
            }
            
            currentDevice += 1
        }
        
        print("CURRENT DEVICE: \(currentDevice)")
        
        if currentDevice >= devices!.count
        {
            print("ERRRRORORO")
        }
        else
        {
            if devices![currentDevice].name != nil && devices![currentDevice].name! != ""
            {
                name.text = devices![currentDevice].name
            }
            
            if devices![currentDevice].password != nil && devices![currentDevice].password! != ""
            {
                password.text = devices![currentDevice].password

            }

            if devices![currentDevice].type != nil && devices![currentDevice].type! != ""
            {
                type.text = devices![currentDevice].type
            }
            
            if devices![currentDevice].icon != nil && devices![currentDevice].icon! != ""
            {
                currentIcon = devices![currentDevice].icon!
                updateSelected()
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func updateSelected()
    {
        defaultOutline.isHidden = !(currentIcon == "default.png")
        laptopOutline.isHidden = !(currentIcon == "laptop.png")
        lightOutline.isHidden = !(currentIcon == "rsz_lightbulb.png")
        gameOutline.isHidden = !(currentIcon == "game.png")
        robotOutline.isHidden = !(currentIcon == "robot.png")
        carOutline.isHidden = !(currentIcon == "rsz_car.png")
    }
    
    @IBAction func defaultSelected(_ sender: Any)
    {
        currentIcon = "default.png"
        updateSelected()
    }
    
    @IBAction func laptopSelected(_ sender: Any)
    {
        currentIcon = "laptop.png"
        updateSelected()
    }
    
    @IBAction func lightSelected(_ sender: Any)
    {
        currentIcon = "rsz_lightbulb.png"
        updateSelected()
    }
    
    @IBAction func gameSelected(_ sender: Any)
    {
        currentIcon = "game.png"
        updateSelected()
    }
    
    @IBAction func robotSelected(_ sender: Any)
    {
        currentIcon = "robot.png"
        updateSelected()
    }
    
    @IBAction func carSelected(_ sender: Any)
    {
        currentIcon = "rsz_car.png"
        updateSelected()
    }
    
    func updateAndSave()
    {
        devices![currentDevice].name = name.text!
        devices![currentDevice].password = password.text!
        devices![currentDevice].icon = currentIcon
        devices![currentDevice].type = type.text!
        
        SystemData().saveDevices(devices: devices!)
    }
    
    @IBAction func statesPressed(_ sender: Any)
    {
        updateAndSave()
        
        self.performSegue(withIdentifier: "configStates", sender: nil)
    }
    
    @IBAction func commandsPressed(_ sender: Any)
    {
        updateAndSave()
        
        self.performSegue(withIdentifier: "configCommands", sender: nil)
    }
    
    @IBAction func backpressed(_ sender: Any)
    {
        devices!.remove(at: currentDevice)
        
        SystemData().saveDevices(devices: devices!)

        
        self.performSegue(withIdentifier: "devback", sender: nil)
    }
    
    func getData()
    {
        var urlStr = "http://108.161.133.186/pi/get.php?accessToken=\(SystemData().loadInText("accessToken.txt")!)"
        
        urlStr = urlStr.replacingOccurrences(of: " ", with: "%20")
        
        print(urlStr)
        
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
                
                var segments = responseString.components(separatedBy: "!@#$")
                
                if segments.count >= 3
                {
                    SystemData().writeTextToFile(segments[0], fileName: "devices.txt")
                    SystemData().writeTextToFile(segments[1], fileName: "states.txt")
                    SystemData().writeTextToFile(segments[2], fileName: "commands.txt")
                    
                    print(responseString)
                    
                    self.performSegue(withIdentifier: "devback", sender: nil)
                }
                
            }
        }
    }
    
    func getSSTR() -> String
    {
        var sstr = ""
        var count = 0
        for st in devices![currentDevice].states
        {
            if count == devices![currentDevice].states.count - 1
            {
                sstr += "\(st.state!)"
            }
            else
            {
                sstr += "\(st.state!)*"
            }
            
            count += 1
        }
        
        return sstr
    }
    
    func getCSTR() -> String
    {
        var sstr = ""
        var count = 0
        for st in devices![currentDevice].states
        {
            if count == devices![currentDevice].states.count - 1
            {
                sstr += "\(st.color!)"
            }
            else
            {
                sstr += "\(st.color!)*"
            }
            
            count += 1
        }
        
        return sstr
    }
    
    func getCMDS() -> String
    {
        var cmds = ""
        var count = 0
        for cm in devices![currentDevice].commands
        {
            if count == devices![currentDevice].commands.count - 1
            {
                cmds += "\(cm.command!)"
            }
            else
            {
                cmds += "\(cm.command!)*"
            }
            
            count += 1
        }
        
        return cmds
    }
    
    func getNSDS() -> String
    {
        var cmds = ""
        var count = 0
        for cm in devices![currentDevice].commands
        {
            if count == devices![currentDevice].commands.count - 1
            {
                cmds += "\(cm.nextState!.state!)"
            }
            else
            {
                cmds += "\(cm.nextState!.state!)*"
            }
            
            count += 1
        }
        
        return cmds
    }
    
    func createDevice()
    {
        let n = name.text!
        let p = password.text!
        let t = type.text!
        let i = currentIcon
        let uat = SystemData().loadInText("accessToken.txt")!
        let s = devices![currentDevice].state!.state!
        let sstr = getSSTR()
        let cstr = getCSTR()
        let cmds = getCMDS()
        let nsds = getNSDS()
        
        var urlStr = "http://108.161.133.186/pi/create_device.php?deviceName=\(n)&password=\(p)&type=\(t)&state=\(s)&icon=\(i)&sstr=\(sstr)&cstr=\(cstr)&cmds=\(cmds)&nsds=\(nsds)&uat=\(uat)"
        
        urlStr = urlStr.replacingOccurrences(of: " ", with: "%20")
        
        print(urlStr)
        
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
                    self.getData();
                }
            }
        }
        
    }
    
    @IBAction func registerPressed(_ sender: Any)
    {
        createDevice()
    }
    
}
