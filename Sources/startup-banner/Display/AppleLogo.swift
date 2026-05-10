/*****************************************************************************************
 * AppleLogo.swift
 *
 * Display Apple logo using Kitty graphics protocol or ASCII art fallback
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :   9-May-2026 10:45pm
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

import Darwin
import Foundation

public enum AppleLogo {
    private static let asciiRows = 29
    private static let defaultLogoPath = "/opt/geedbla/pictures/apple-logo.png"

    @discardableResult
    public static func display(supportsKitty: Bool, imagePath: String? = nil) -> Int {
        print("\u{1B}[0;0H", terminator: "")

        let path = imagePath ?? defaultLogoPath
        if supportsKitty, FileManager.default.fileExists(atPath: path) {
            return displayKitty(path: path)
        } else {
            displayASCII()
            return asciiRows
        }
    }

    private static func displayKitty(path: String) -> Int {
        guard let data = FileManager.default.contents(atPath: path) else {
            displayASCII()
            return asciiRows
        }

        let encoded = data.base64EncodedString()
        print("\u{1B}_Ga=T,f=100;\(encoded)\u{1B}\\", terminator: "")
        fflush(stdout)
        return queryCursorRow() ?? asciiRows
    }

    private static func queryCursorRow() -> Int? {
        guard isatty(STDIN_FILENO) != 0, isatty(STDOUT_FILENO) != 0 else { return nil }

        var original = termios()
        guard tcgetattr(STDIN_FILENO, &original) == 0 else { return nil }
        defer { _ = tcsetattr(STDIN_FILENO, TCSANOW, &original) }

        var raw = original
        raw.c_lflag &= ~(tcflag_t(ICANON) | tcflag_t(ECHO))
        withUnsafeMutableBytes(of: &raw.c_cc) { buffer in
            let bytes = buffer.bindMemory(to: cc_t.self)
            bytes[Int(VMIN)] = 0
            bytes[Int(VTIME)] = 2
        }
        guard tcsetattr(STDIN_FILENO, TCSANOW, &raw) == 0 else { return nil }

        let query: [UInt8] = Array("\u{1B}[6n".utf8)
        _ = query.withUnsafeBufferPointer { buf in
            write(STDOUT_FILENO, buf.baseAddress, buf.count)
        }

        var response: [UInt8] = []
        while response.last != UInt8(ascii: "R"), response.count < 32 {
            var byte: UInt8 = 0
            let n = read(STDIN_FILENO, &byte, 1)
            if n != 1 { break }
            response.append(byte)
        }

        guard let leftBracket = response.firstIndex(of: UInt8(ascii: "[")),
              let semicolon = response.firstIndex(of: UInt8(ascii: ";")),
              leftBracket < semicolon
        else { return nil }
        let rowsBytes = response[(leftBracket + 1) ..< semicolon]
        return Int(String(decoding: rowsBytes, as: UTF8.self))
    }

    private static func displayASCII() {
        let g = "\u{1B}[38;5;034m"
        let y = "\u{1B}[38;5;226m"
        let o = "\u{1B}[38;5;208m"
        let r = "\u{1B}[38;5;196m"
        let p = "\u{1B}[38;5;129m"
        let b = "\u{1B}[38;5;038m"
        let reset = "\u{1B}[0m"

        print("""
        \(g)                                        @@
        \(g)                                    @@@@@@
        \(g)                                 @@@@@@@@
        \(g)                               @@@@@@@@@@
        \(g)                              @@@@@@@@@@
        \(g)                             @@@@@@@@@@
        \(g)                             @@@@@@@@
        \(g)                            @@@@@@
        \(g)                            @@
        \(g)           @@@@@@@@@@@@        @@@@@@@@@@@@@@@
        \(g)        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        \(g)      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        \(g)    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        \(y)   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        \(y)  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        \(o) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        \(o) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        \(r) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        \(r) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        \(r)  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        \(r)   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        \(p)    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        \(p)     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        \(p)      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        \(b)        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        \(b)          @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        \(b)            @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        \(b)              @@@@@@@@@          @@@@@@@@@
        \(reset)
        """)
    }
}
