//
//  Device.swift
//  PIRemote
//
//  Created by Will Engel on 4/15/17.
//  Copyright © 2017 SnappyApps. All rights reserved.
//

import Foundation

class Device
{
    var id : String?
    var name : String?
    var commands = [Command]()
    var states = [State]()
    var type : String?
    var state : State?
    var icon : String?
    var password : String?
    var accessToken : String?
    
    init(id: String?, name: String?, type: String?, state: State?, icon: String?, password: String?, accessToken: String?)
    {
        self.id = id
        self.name = name
        self.type = type
        self.state = state
        self.icon = icon
        self.password = password
        self.accessToken = accessToken
    }
}
