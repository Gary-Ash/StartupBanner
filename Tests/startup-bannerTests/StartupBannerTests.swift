/*****************************************************************************************
 * StartupBannerTests.swift
 *
 * Unit tests for startup-banner utility functions
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :  10-Feb-2026  3:30pm
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

import Testing

@testable import StartupBannerLib

@Test func diskFormatBytes_GB() {
    let result = DiskInfo.formatBytes(500_000_000_000)
    #expect(result == "500 GB")
}

@Test func diskFormatBytes_TB() {
    let result = DiskInfo.formatBytes(2_000_000_000_000)
    #expect(result == "2.0 TB")
}

@Test func diskFormatBytes_smallGB() {
    let result = DiskInfo.formatBytes(135_000_000_000)
    #expect(result == "135 GB")
}

@Test func uptimeFormatting() {
    let info = UptimeInfo.gather()
    if case let .uptime(text) = info {
        #expect(text.contains("days,"))
    }
}

@Test func osInfoReturnsResult() {
    let info = OSInfo.gather()
    if case let .os(text) = info {
        #expect(text.contains("macOS"))
    }
}

@Test func userInfoReturnsNonEmpty() {
    let info = UserInfo.gather()
    if case let .user(name) = info {
        #expect(!name.isEmpty)
    }
}
