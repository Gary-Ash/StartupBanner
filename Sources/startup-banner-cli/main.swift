/*****************************************************************************************
 * main.swift
 *
 * Entry point - parses arguments, gathers system info concurrently, renders banner
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :   9-May-2026 10:45pm
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

import Foundation
import StartupBannerLib

struct Options {
    var theme: ANSITheme = .light
    var imagePath: String?
}

func parseArguments() -> Options {
    var options = Options()
    let args = Array(CommandLine.arguments.dropFirst())
    var index = 0
    while index < args.count {
        let arg = args[index]
        switch arg {
        case "-l", "--light":
            options.theme = .light
        case "-d", "--dark":
            options.theme = .dark
        case "-i", "--image":
            index += 1
            guard index < args.count else {
                FileHandle.standardError.write(Data("**** Missing path for \(arg)\n".utf8))
                exit(2)
            }
            options.imagePath = args[index]
        default:
            FileHandle.standardError.write(Data("**** Unknown argument: \(arg)\n".utf8))
            exit(2)
        }
        index += 1
    }
    return options
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

let options = parseArguments()
let info = await gatherAllInfo()
let renderer = BannerRenderer(theme: options.theme, imagePath: options.imagePath)
renderer.render(info)
