//
//  DeviceConnectionViewController.swift
//  PIRemote
//
//  Created by Will Engel on 4/16/17.
//  Copyright © 2017 SnappyApps. All rights reserved.
//

import UIKit

class DeviceConnectionViewController: UIViewController
{
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var pass: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
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
                    
                    self.performSegue(withIdentifier: "todev", sender: nil)
                }
                
            }
        }
    }
    
    func signin()
    {
        let u = name.text!
        let p = pass.text!
        let t = SystemData().loadInText("accessToken.txt")!
        
        var urlStr = "http://108.161.133.186/pi/dev_conn.php?name=\(u)&password=\(p)&uat=\(t)"
        
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
                    self.getData();
                }
            }
        }
        
    }

    
    @IBAction func connect(_ sender: Any)
    {
        self.signin()
    }
    
}
