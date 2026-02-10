/*****************************************************************************************
 * GPUInfo.swift
 *
 * Gather GPU information - skipped on ARM (GPU is the chip itself)
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

import Foundation

public enum GPUInfo {
    public static func gather() async -> InfoResult {
        #if arch(arm64)
            return .gpu(nil)
        #else
            let output = await SubprocessRunner.run(
                "/usr/sbin/system_profiler", "SPDisplaysDataType"
            )

            var chipset: String?
            var vram: String?

            for line in output.components(separatedBy: "\n") {
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                if trimmed.hasPrefix("Chipset Model:") {
                    chipset = trimmed.replacingOccurrences(of: "Chipset Model: ", with: "")
                } else if trimmed.hasPrefix("VRAM (Total):") {
                    vram = trimmed.replacingOccurrences(of: "VRAM (Total): ", with: "")
                }
            }

            if let chipset {
                var result = chipset
                if let vram {
                    result += " - \(vram) Video RAM"
                }
                return .gpu(result)
            }
            return .gpu(nil)
        #endif
    }
}
