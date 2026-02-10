/*****************************************************************************************
 * SubprocessRunner.swift
 *
 * Async wrapper for running external commands via Process
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

import Foundation

public enum SubprocessRunner {
    public static func run(_ executable: String, _ arguments: String...) async -> String {
        await run(executable, arguments: arguments)
    }

    public static func run(_ executable: String, arguments: [String]) async -> String {
        await withCheckedContinuation { continuation in
            let process = Process()
            process.executableURL = URL(fileURLWithPath: executable)
            process.arguments = arguments
            let pipe = Pipe()
            process.standardOutput = pipe
            process.standardError = FileHandle.nullDevice

            do {
                try process.run()
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                process.waitUntilExit()
                let output = String(data: data, encoding: .utf8)?
                    .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                continuation.resume(returning: output)
            } catch {
                continuation.resume(returning: "")
            }
        }
    }
}
