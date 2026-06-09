/*****************************************************************************************
 * UptimeInfo.swift
 *
 * Gather system uptime and format as days, hours, minutes
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :   9-Jun-2026  3:52pm
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

import Foundation

public enum UptimeInfo {
    public static func gather() -> InfoResult {
        let totalMinutes = Int(ProcessInfo.processInfo.systemUptime) / 60
        return .uptime(format(minutes: totalMinutes))
    }

    static func format(minutes totalMinutes: Int) -> String {
        let days = totalMinutes / (60 * 24)
        let hours = (totalMinutes % (60 * 24)) / 60
        let minutes = totalMinutes % 60

        let minuteLabel = minutes == 1 ? "minute" : "minutes"
        let hourLabel = hours == 1 ? "hour" : "hours"

        if days > 0 {
            let dayLabel = days == 1 ? "day" : "days"
            return "\(days) \(dayLabel), \(hours) \(hourLabel) \(minutes) \(minuteLabel)"
        }
        if hours > 0 {
            return "\(hours) \(hourLabel) \(minutes) \(minuteLabel)"
        }
        return "\(minutes) \(minuteLabel)"
    }
}
