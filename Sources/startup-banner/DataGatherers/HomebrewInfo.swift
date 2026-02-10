/*****************************************************************************************
 * HomebrewInfo.swift
 *
 * Gather Homebrew package counts running brew list and brew outdated concurrently
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

import Foundation

public enum HomebrewInfo {
    public static func gather() async -> InfoResult {
        let brewPath: String
        if FileManager.default.isExecutableFile(atPath: "/opt/homebrew/bin/brew") {
            brewPath = "/opt/homebrew/bin/brew"
        } else if FileManager.default.isExecutableFile(atPath: "/usr/local/bin/brew") {
            brewPath = "/usr/local/bin/brew"
        } else {
            return .homebrew(available: false, installed: 0, outdated: 0)
        }

        async let installedOutput = SubprocessRunner.run(brewPath, "list", "--formula")
        async let outdatedOutput = SubprocessRunner.run(brewPath, "outdated")

        let installed = await installedOutput
        let outdated = await outdatedOutput

        let installedCount = installed.isEmpty ? 0 : installed.components(separatedBy: "\n").count
        let outdatedCount = outdated.isEmpty ? 0 : outdated.components(separatedBy: "\n").count

        return .homebrew(available: true, installed: installedCount, outdated: outdatedCount)
    }
}
