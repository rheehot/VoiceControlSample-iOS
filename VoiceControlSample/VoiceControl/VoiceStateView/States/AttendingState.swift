//
//  AttendingState.swift
//  VoiceControlSample
//
//  Created by Soojin Ro on 2020/01/03.
//  Copyright © 2020 nsoojin. All rights reserved.
//

import UIKit
import GameplayKit

internal final class AttendingState: VoiceState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is DetectingState.Type
    }
}
