//
//  SprintTimer.swift
//  sprint-task
//
//  Created by Maurice Tin on 04/05/21.
//

import Foundation

struct SprintTimer {
    var sprintDuration: Int
    var breakDuration: Int
    var totalSprints: Int
    var currentSprint: Int
    var modeIsSprint: Bool
    var isTimerRunning: Bool
    
    
    init(sprintDuration: Int, breakDuration: Int, totalSprints: Int) {
        self.sprintDuration = sprintDuration
        self.breakDuration = breakDuration
        self.totalSprints = totalSprints
        self.currentSprint = 1
        self.modeIsSprint = true
        self.isTimerRunning = false
    }
}

var mySprintTimer = SprintTimer(sprintDuration: 25, breakDuration: 5, totalSprints: 3)

