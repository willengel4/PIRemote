//
//  SignUpViewController.swift
//  PIRemote
//
//  Created by Will Engel on 4/15/17.
//  Copyright © 2017 SnappyApps. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController : UIViewController
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var last: UITextField!
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var pass: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
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
    
    
    @IBAction func signUpPressed(_ sender: Any)
    {
        let f = first.text!
        let l = last.text!
        let u = user.text!
        let p = pass.text!
        
        var urlStr = "http://108.161.133.186/pi/sign_up.php?first=\(f)&last=\(l)&username=\(u)&password=\(p)"
        
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
                    SystemData().writeTextToFile(responseString, fileName: "accessToken.txt")
                    
                    SystemData().writeTextToFile("", fileName: "devices.txt")
                    SystemData().writeTextToFile("", fileName: "states.txt")
                    SystemData().writeTextToFile("", fileName: "commands.txt")
                }
            }
        }

    }
    
    @IBAction func usernameBeginEdit(_ sender: Any)
    {
        scrollView.setContentOffset(CGPoint(x: 0, y: 30), animated: true)
    }
    
    @IBAction func usernameEndEdit(_ sender: Any)
    {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func passwordBeginEdit(_ sender: Any)
    {
        scrollView.setContentOffset(CGPoint(x: 0, y: 60), animated: true)
    }
    
    @IBAction func passwordEndEdit(_ sender: Any)
    {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
