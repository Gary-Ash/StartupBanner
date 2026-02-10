/*****************************************************************************************
 * ShellInfo.swift
 *
 * Detect the user's shell and its version
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

import Foundation

public enum ShellInfo {
    public static func gather() async -> InfoResult {
        let shellPath = ProcessInfo.processInfo.environment["SHELL"] ?? "/bin/zsh"

        if shellPath.contains("zsh") {
            let version = await SubprocessRunner.run(shellPath, "-c", "echo $ZSH_VERSION")
            return .shell("ZSH v\(version) (\(shellPath))")
        } else if shellPath.contains("bash") {
            let version = await SubprocessRunner.run(
                shellPath, "-c",
                "echo ${BASH_VERSINFO[0]}.${BASH_VERSINFO[1]}.${BASH_VERSINFO[2]}"
            )
            return .shell("Bash v\(version) (\(shellPath))")
        }

        return .shell(shellPath)
    }
}
