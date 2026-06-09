/*****************************************************************************************
 * StartupBannerTests.swift
 *
 * Unit tests for startup-banner utility functions
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :   9-Jun-2026  3:52pm
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
        #expect(text.contains("minute"))
    }
}

@Test func uptimeOmitsHoursUnderOneHour() {
    #expect(UptimeInfo.format(minutes: 0) == "0 minutes")
    #expect(UptimeInfo.format(minutes: 1) == "1 minute")
    #expect(UptimeInfo.format(minutes: 59) == "59 minutes")
}

@Test func uptimeShowsHoursAtOrAboveOneHour() {
    #expect(UptimeInfo.format(minutes: 60) == "1 hour 0 minutes")
    #expect(UptimeInfo.format(minutes: 175) == "2 hours 55 minutes")
}

@Test func uptimeShowsDays() {
    #expect(UptimeInfo.format(minutes: 1500) == "1 day, 1 hour 0 minutes")
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
