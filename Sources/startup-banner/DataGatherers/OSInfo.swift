/*****************************************************************************************
 * OSInfo.swift
 *
 * Gather OS version and map to friendly marketing name
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

import Foundation

public enum OSInfo {
    private static let versionNames: [Int: String] = [
        11: "macOS Big Sur",
        12: "macOS Monterey",
        13: "macOS Ventura",
        14: "macOS Sonoma",
        15: "macOS Sequoia",
        26: "macOS Tahoe",
    ]

    private static let legacyMinorNames: [Int: String] = [
        12: "macOS Sierra",
        13: "macOS High Sierra",
        14: "macOS Mojave",
        15: "macOS Catalina",
    ]

    public static func gather() -> InfoResult {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        let major = version.majorVersion
        let minor = version.minorVersion
        let patch = version.patchVersion

        let friendlyName: String
        if major == 10 {
            friendlyName = legacyMinorNames[minor] ?? "macOS"
        } else {
            friendlyName = versionNames[major] ?? "macOS"
        }

        let buildNumber = Sysctl.string("kern.osversion") ?? ""
        let versionString: String
        if major == 10 {
            versionString = "\(friendlyName) \(major).\(minor).\(patch) (\(buildNumber))"
        } else {
            versionString = "\(friendlyName) \(major).\(minor) (\(buildNumber))"
        }

        return .os(versionString)
    }
}
