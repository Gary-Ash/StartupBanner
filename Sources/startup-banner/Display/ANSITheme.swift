/*****************************************************************************************
 * ANSITheme.swift
 *
 * ANSI escape sequence themes for light and dark terminal backgrounds
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :  22-Feb-2026
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

public struct ANSITheme: Sendable {
    public init(headingText: String, highlightText: String, normalText: String, problemText: String) {
        self.headingText = headingText
        self.highlightText = highlightText
        self.normalText = normalText
        self.problemText = problemText
    }
    public let headingText: String
    public let highlightText: String
    public let normalText: String
    public let problemText: String

    public static let light = ANSITheme(
        headingText: "\u{1B}[1m",
        highlightText: "\u{1B}[1m\u{1B}[38;2;0;0;0m",
        normalText: "\u{1B}[0m",
        problemText: "\u{1B}[1m\u{1B}[38;2;204;0;0m"
    )

    public static let dark = ANSITheme(
        headingText: "\u{1B}[1m\u{1B}[38;2;255;255;255m",
        highlightText: "\u{1B}[1m\u{1B}[38;2;255;255;255m",
        normalText: "\u{1B}[0m",
        problemText: "\u{1B}[1m\u{1B}[38;2;204;0;0m"
    )
}
