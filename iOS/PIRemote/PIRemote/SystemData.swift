//
//  SystemData.swift
//  PIRemote
//
//  Created by Will Engel on 4/15/17.
//  Copyright © 2017 SnappyApps. All rights reserved.
//

import Foundation

class SystemData
{
    func loadInText(_ file : String) -> String?
    {
        /* The document directory */
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first
        {
            /* The full path to the file */
            let path = URL(fileURLWithPath: dir).appendingPathComponent(file)
            
            do
            {
                /* Get the text in the file and return it */
                let text2 = try NSString(contentsOf: path, encoding: String.Encoding.utf8.rawValue) as String
                
                return text2
            }
            catch
            {
                /* If there was an error, the access token probably doesn't exist */
                print("Error reading from " + file)
            }
        }
        
        return nil
    }
    
    /* This function will write the specified text to the specified file */
    func writeTextToFile(_ text : String, fileName : String)
    {
        /* Get the path to the documents directory */
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first
        {
            /* The full path */
            let path = URL(fileURLWithPath: dir).appendingPathComponent(fileName)
            
            do
            {
                /* Do the writing */
                try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch
            {
                print("error writing to " + fileName)
            }
        }
    }
    
    func loadDevices() -> [Device]
    {
        var devices = [Device]()
        var commands = [String:[Command]]()
        var states = [String:State]()
        var states2 = [String:[State]]()
        
        let statesText = loadInText("states.txt")!
        let commandsText = loadInText("commands.txt")!
        let devicesText = loadInText("devices.txt")!
        
        print(devicesText)
        print("-----------------------")
        print(statesText)
        print("-------------------------")
        print(commandsText)
        
        let statesLines = statesText.components(separatedBy: "\n")
        let commandsLines = commandsText.components(separatedBy: "\n")
        let devicesLines = devicesText.components(separatedBy: "\n")
        
        for line in statesLines
        {
            let tokens = line.components(separatedBy: "*")
            
            if tokens.count >= 4
            {
                let state = State(id: tokens[1], state: tokens[2], color: tokens[3])
                states[state.id!] = state
                
                if states2[tokens[0]] == nil
                {
                    states2[tokens[0]] = [State]()
                }
                
                states2[tokens[0]]?.append(state)
            }
        }
        
        for line in commandsLines
        {
            let tokens = line.components(separatedBy: "*")
            
            if tokens.count >= 3
            {
                let command = Command(devID: tokens[0], command: tokens[1], nextState: states[tokens[2]])
                
                if commands[tokens[0]] == nil
                {
                    commands[tokens[0]] = [Command]()
                }
                
                commands[tokens[0]]!.append(command)
            }
            

        }
        
        for line in devicesLines
        {
            let tokens = line.components(separatedBy: "*")

            
            if tokens.count >= 7
            {
                let device = Device(id: tokens[0], name: tokens[1], type: tokens[2], state: states[tokens[3]], icon: tokens[4], password: tokens[5], accessToken: tokens[6])
                
                if commands[device.id!] != nil
                {
                    for command in commands[device.id!]!
                    {
                        device.commands.append(command)
                    }
                }

                if states2[device.id!] != nil
                {
                    for state in states2[device.id!]!
                    {
                        device.states.append(state)
                    }
                }

                
                devices.append(device)
            }
            

        }
        
        return devices
    }
    
    func saveDevices(devices: [Device])
    {
        var devicesFile = ""
        var commandsFile = ""
        var statesFile = ""
        
        for device in devices
        {
            let n = device.name == nil ? "" : device.name!
            let t = device.type == nil ? "" : device.type!
            let s = device.state == nil ? "" : device.state!.id!
            let i = device.icon == nil ? "" : device.icon!
            let p = device.password == nil ? "" : device.password!
            let at = device.accessToken == nil ? "" : device.accessToken!
            devicesFile += "\(device.id!)*\(n)*\(t)*\(s)*\(i)*\(p)*\(at)\n"
            
            for command in device.commands
            {
                commandsFile += "\(device.id!)*\(command.command!)*\(command.nextState!.id!)\n"
            }
            
            for state in device.states
            {
                statesFile += "\(device.id!)*\(state.id!)*\(state.state!)*\(state.color!)\n"
            }
        }
        
        print(devicesFile)
        print("-------")
        print(commandsFile)
        print("-------")
        print(statesFile)
        
        self.writeTextToFile(devicesFile, fileName: "devices.txt")
        self.writeTextToFile(commandsFile, fileName: "commands.txt")
        self.writeTextToFile(statesFile, fileName: "states.txt")
    }

}

