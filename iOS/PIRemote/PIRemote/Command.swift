//
//  Command.swift
//  PIRemote
//
//  Created by Will Engel on 4/15/17.
//  Copyright © 2017 SnappyApps. All rights reserved.
//

import Foundation
import UIKit

class Command
{
    var devID : String?
    var command : String?
    var nextState : State?
    
    init(devID: String?, command: String, nextState: State?)
    {
        self.command = command
        self.nextState = nextState
    }
}
