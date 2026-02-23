/*****************************************************************************************
 * BannerRenderer.swift
 *
 * Assemble and render system specs alongside the Apple logo
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :  24-Feb-2026 10:09pm
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

import Foundation

public struct BannerRenderer {
    public init(theme: ANSITheme) { self.theme = theme }
    public let theme: ANSITheme

    public func render(_ info: SystemInfo) {
        var specs: [String] = []

        specs.append("User         : \(info.userName)")
        specs.append("OS           : \(info.osVersion)")

        if info.homebrewAvailable {
            let outdatedText: String
            if info.homebrewOutdated > 0 {
                outdatedText = "\(theme.highlightText)\(info.homebrewOutdated)\(theme.normalText)"
            } else {
                outdatedText = "\(info.homebrewOutdated)"
            }
            specs.append("Homebrew     : \(info.homebrewInstalled) Packages \(outdatedText) Updates")
        }

        specs.append("Shell        : \(info.shell)")
        if let model = info.marketingModel {
            specs.append("Machine      : \(info.machineName) - \(model)")
        } else {
            specs.append("Machine      : \(info.machineName)")
        }
        specs.append("             : \(info.chipName) \(info.coreCount) Cores \(info.memory) Memory")

        if let gpu = info.gpu {
            specs.append("GPU          : \(gpu)")
        }

        if let battery = info.batteryStatus {
            specs.append("Power        : \(battery)")
        }

        specs.append("IP Addresses : \(info.internalIP)/\(info.externalIP)")
        specs.append(
            "Boot Disk    : \(info.bootVolume) Size: \(info.diskSize) Used: \(info.diskUsed)  Free: \(info.diskFree)"
        )
        specs.append("Up Time      : \(info.uptime)")

        let longest = specs.reduce(0) { max($0, stripANSI($1).count) }
        let specsColumn = max(1, (info.terminalColumns - longest) / 2 + 10)

        print("\u{1B}[2J\u{1B}[H", terminator: "")
        AppleLogo.display(supportsKitty: info.supportsKitty)

        for (index, text) in specs.enumerated() {
            let row = index + 1
            let colonIndex = text.firstIndex(of: ":")
            if let colonIndex {
                let heading = String(text[text.startIndex ... colonIndex])
                let value = String(text[text.index(after: colonIndex)...])
                print(
                    "\u{1B}[\(row);\(specsColumn)H\(theme.headingText)\(heading)\(theme.normalText)\(value)",
                    terminator: ""
                )
            } else {
                print("\u{1B}[\(row);\(specsColumn)H\(theme.normalText)\(text)", terminator: "")
            }
        }

        print("\n\n")
    }

    private func stripANSI(_ text: String) -> String {
        text.replacingOccurrences(
            of: "\u{1B}\\[[0-9;]*m",
            with: "",
            options: .regularExpression
        )
    }
}
