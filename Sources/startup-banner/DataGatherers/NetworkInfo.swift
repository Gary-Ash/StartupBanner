/*****************************************************************************************
 * NetworkInfo.swift
 *
 * Gather internal IP via getifaddrs and external IP via dig subprocess
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

import Darwin
import Foundation

public enum NetworkInfo {
    public static func gatherInternalIP() -> InfoResult {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else {
            return .internalIP("N/A")
        }
        defer { freeifaddrs(ifaddr) }

        var current = firstAddr
        while true {
            let interface = current.pointee
            let name = String(cString: interface.ifa_name)

            if name == "en0",
               interface.ifa_addr.pointee.sa_family == UInt8(AF_INET)
            {
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                if getnameinfo(
                    interface.ifa_addr,
                    socklen_t(interface.ifa_addr.pointee.sa_len),
                    &hostname,
                    socklen_t(hostname.count),
                    nil, 0,
                    NI_NUMERICHOST
                ) == 0 {
                    let nullTerminated = hostname.prefix(while: { $0 != 0 })
                    let ip = String(decoding: nullTerminated.map { UInt8(bitPattern: $0) }, as: UTF8.self)
                    return .internalIP(ip)
                }
            }

            guard let next = interface.ifa_next else { break }
            current = next
        }

        return .internalIP("N/A")
    }

    public static func gatherExternalIP() async -> InfoResult {
        let ip = await SubprocessRunner.run(
            "/usr/bin/dig", "+short", "myip.opendns.com", "@resolver1.opendns.com"
        )
        return .externalIP(ip.isEmpty ? "N/A" : ip)
    }
}
