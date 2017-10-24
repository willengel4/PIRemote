//
//  State.swift
//  PIRemote
//
//  Created by Will Engel on 4/15/17.
//  Copyright © 2017 SnappyApps. All rights reserved.
//

import Foundation


class State
{
    var id : String?
    var state : String?
    var color : String?
    
    init(id: String?, state: String, color: String)
    {
        self.id = id
        self.state = state
        self.color = color
    }
}
