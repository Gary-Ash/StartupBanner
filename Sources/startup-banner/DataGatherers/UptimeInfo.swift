/*****************************************************************************************
 * UptimeInfo.swift
 *
 * Gather system uptime and format as days, hours:minutes
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :
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

        return .uptime("\(days) days, \(hours):\(String(format: "%02d", minutes))")
    }
}
