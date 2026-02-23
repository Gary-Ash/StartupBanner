/*****************************************************************************************
 * UptimeInfo.swift
 *
 * Gather system uptime and format as days, hours, minutes
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :  23-Feb-2026
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

import Foundation

public enum UptimeInfo {
    public static func gather() -> InfoResult {
        let uptime = ProcessInfo.processInfo.systemUptime
        let totalMinutes = Int(uptime) / 60
        let days = totalMinutes / (60 * 24)
        let hours = (totalMinutes % (60 * 24)) / 60
        let minutes = totalMinutes % 60

        let hourLabel = hours == 1 ? "hour" : "hours"
        let minuteLabel = minutes == 1 ? "minute" : "minutes"
        let timeString: String
        if days > 0 {
            let dayLabel = days == 1 ? "day" : "days"
            timeString = "\(days) \(dayLabel), \(hours) \(hourLabel) \(minutes) \(minuteLabel)"
        } else {
            timeString = "\(hours) \(hourLabel) \(minutes) \(minuteLabel)"
        }
        return .uptime(timeString)
    }
}
