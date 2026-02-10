/*****************************************************************************************
 * DiskInfo.swift
 *
 * Gather boot disk volume name and usage via statfs
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

import Darwin
import Foundation

public enum DiskInfo {
    public static func gather() -> InfoResult {
        let volumeName = bootVolumeName()

        var stat = statfs()
        guard statfs("/", &stat) == 0 else {
            return .disk(volumeName: volumeName, size: "N/A", used: "N/A", free: "N/A")
        }

        let blockSize = UInt64(stat.f_bsize)
        let totalBytes = UInt64(stat.f_blocks) * blockSize
        let freeBytes = UInt64(stat.f_bavail) * blockSize
        let usedBytes = totalBytes - freeBytes

        return .disk(
            volumeName: volumeName,
            size: formatBytes(totalBytes),
            used: formatBytes(usedBytes),
            free: formatBytes(freeBytes)
        )
    }

    private static func bootVolumeName() -> String {
        let url = URL(fileURLWithPath: "/")
        if let values = try? url.resourceValues(forKeys: [.volumeNameKey]),
           let name = values.volumeName
        {
            return name
        }
        return "Macintosh HD"
    }

    public static func formatBytes(_ bytes: UInt64) -> String {
        let tb = Double(bytes) / 1_000_000_000_000
        if tb >= 1.0 {
            return String(format: "%.1f TB", tb)
        }
        let gb = Double(bytes) / 1_000_000_000
        return String(format: "%.0f GB", gb)
    }
}
