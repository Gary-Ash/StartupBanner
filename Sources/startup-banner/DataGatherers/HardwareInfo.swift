/*****************************************************************************************
 * HardwareInfo.swift
 *
 * Gather CPU, memory, model, and machine name via sysctl and embedded model table
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :   9-Jun-2026  3:52pm
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

import Foundation

public enum HardwareInfo {
    public static func gatherMachine() -> InfoResult {
        let computerName = Host.current().localizedName ?? "Unknown"
        let modelID = Sysctl.string("hw.model") ?? "Unknown"
        let marketingModel = lookupMarketingModel(modelID)
        return .machine(name: computerName, marketingModel: marketingModel)
    }

    public static func gatherHardware() -> InfoResult {
        let chip = Sysctl.string("machdep.cpu.brand_string") ?? "Unknown"
        let coreCount = Sysctl.int32("hw.ncpu").map { String($0) } ?? "Unknown"
        let memBytes = Sysctl.uint64("hw.memsize") ?? 0
        let memGB = memBytes / (1024 * 1024 * 1024)
        let memory = "\(memGB) GB"
        return .hardware(chip: chip, cores: coreCount, memory: memory)
    }

    static func lookupMarketingModel(_ modelID: String) -> String? {
        macModels[modelID]?.readableName
    }
}
