/*****************************************************************************************
 * TerminalInfo.swift
 *
 * Detect terminal width and Kitty graphics protocol support
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

import Darwin
import Foundation

public enum TerminalInfo {
    public static func gather() -> InfoResult {
        var ws = winsize()
        let columns: Int
        if ioctl(STDOUT_FILENO, TIOCGWINSZ, &ws) == 0, ws.ws_col > 0 {
            columns = Int(ws.ws_col)
        } else if let colsEnv = ProcessInfo.processInfo.environment["COLUMNS"],
                  let cols = Int(colsEnv)
        {
            columns = cols
        } else {
            columns = 120
        }

        let termProgram = ProcessInfo.processInfo.environment["TERM_PROGRAM"] ?? ""
        let supportsKitty = termProgram != "Apple_Terminal" && !termProgram.isEmpty

        return .terminal(columns: columns, supportsKitty: supportsKitty)
    }
}
