/*****************************************************************************************
 * main.swift
 *
 * Entry point - parses arguments, gathers system info concurrently, renders banner
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

import Foundation
import StartupBannerLib

func parseArguments() -> ANSITheme {
    let args = CommandLine.arguments.dropFirst()
    for arg in args {
        switch arg {
        case "-l", "--light":
            return .light
        case "-d", "--dark":
            return .dark
        default:
            FileHandle.standardError.write(Data("**** Unknown argument: \(arg)\n".utf8))
            exit(2)
        }
    }
    return .light
}

func gatherAllInfo() async -> SystemInfo {
    await withTaskGroup(of: InfoResult.self) { group in
        group.addTask { UserInfo.gather() }
        group.addTask { OSInfo.gather() }
        group.addTask { HardwareInfo.gatherMachine() }
        group.addTask { HardwareInfo.gatherHardware() }
        group.addTask { BatteryInfo.gather() }
        group.addTask { NetworkInfo.gatherInternalIP() }
        group.addTask { DiskInfo.gather() }
        group.addTask { UptimeInfo.gather() }
        group.addTask { TerminalInfo.gather() }

        group.addTask { await NetworkInfo.gatherExternalIP() }
        group.addTask { await ShellInfo.gather() }
        group.addTask { await HomebrewInfo.gather() }
        group.addTask { await GPUInfo.gather() }

        var builder = SystemInfoBuilder()
        for await result in group {
            builder.apply(result)
        }
        return builder.build()
    }
}

let theme = parseArguments()
let info = await gatherAllInfo()
let renderer = BannerRenderer(theme: theme)
renderer.render(info)
