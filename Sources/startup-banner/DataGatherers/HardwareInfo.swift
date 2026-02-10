/*****************************************************************************************
 * HardwareInfo.swift
 *
 * Gather CPU, memory, model, and machine name via sysctl and plist lookup
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

import Foundation

public enum HardwareInfo {
    private static let modelNames: [String: String] = [
        "MacBookPro16,1": "16\" MacBook Pro (2019) True Tone Display",
        "iMac20,2": "iMac 5k 27\" (2020) True Tone Display",
        "Mac13,2": "Mac Studio 2022",
        "Mac14,6": "16\" MacBook Pro (2023) Retina XDR Display",
    ]

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

    private static func lookupMarketingModel(_ modelID: String) -> String? {
        let plistPaths = [
            "/System/Library/PrivateFrameworks/ServerInformation.framework/Versions/A/Resources/English.lproj/SIMachineAttributes.plist",
            "/System/Library/PrivateFrameworks/ServerInformation.framework/Versions/A/Resources/en.lproj/SIMachineAttributes.plist",
        ]

        for path in plistPaths {
            if let dict = NSDictionary(contentsOfFile: path),
               let modelDict = dict[modelID] as? NSDictionary,
               let localizable = modelDict["_LOCALIZABLE_"] as? NSDictionary,
               let name = localizable["marketingModel"] as? String
            {
                return name
            }
        }

        return modelNames[modelID]
    }
}
