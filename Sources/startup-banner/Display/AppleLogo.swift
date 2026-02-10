/*****************************************************************************************
 * AppleLogo.swift
 *
 * Display Apple logo using Kitty graphics protocol or ASCII art fallback
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

import Foundation

public enum AppleLogo {
    private static let logoPath = "/opt/geedbla/pictures/apple-logo.png"

    public static func display(supportsKitty: Bool) {
        print("\u{1B}[0;0H", terminator: "")

        if supportsKitty, FileManager.default.fileExists(atPath: logoPath) {
            displayKitty()
        } else {
            displayASCII()
        }
    }

    private static func displayKitty() {
        guard let data = FileManager.default.contents(atPath: logoPath) else {
            displayASCII()
            return
        }

        let encoded = data.base64EncodedString()
        print("\u{1B}_Ga=T,f=100;\(encoded)\u{1B}\\", terminator: "")
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
