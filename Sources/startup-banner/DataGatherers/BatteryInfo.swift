/*****************************************************************************************
 * BatteryInfo.swift
 *
 * Gather battery/power status via IOPowerSources
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

import Foundation
import IOKit.ps

public enum BatteryInfo {
    public static func gather() -> InfoResult {
        let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as [CFTypeRef]

        guard !sources.isEmpty,
              let source = sources.first,
              let description = IOPSGetPowerSourceDescription(snapshot, source)?.takeUnretainedValue()
                  as? [String: Any]
        else {
            return .battery(nil)
        }

        let powerSource = description[kIOPSPowerSourceStateKey as String] as? String ?? ""
        let currentCapacity = description[kIOPSCurrentCapacityKey as String] as? Int ?? 0

        if powerSource == kIOPSACPowerValue as String {
            if description[kIOPSIsChargingKey as String] as? Bool == true {
                return .battery("Charging on AC Power Battery charge at \(currentCapacity)%")
            }
            return .battery(nil)
        } else {
            return .battery("Running on Battery Power charge at \(currentCapacity)%")
        }
    }
}
