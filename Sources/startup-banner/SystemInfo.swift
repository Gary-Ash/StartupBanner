/*****************************************************************************************
 * SystemInfo.swift
 *
 * Data model for gathered system information, result enum, and builder
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

public struct SystemInfo: Sendable {
    public init() {}
    public var userName: String = ""
    public var osVersion: String = ""
    public var homebrewInstalled: Int = 0
    public var homebrewOutdated: Int = 0
    public var homebrewAvailable: Bool = false
    public var shell: String = ""
    public var machineName: String = ""
    public var marketingModel: String?
    public var chipName: String = ""
    public var coreCount: String = ""
    public var memory: String = ""
    public var gpu: String?
    public var batteryStatus: String?
    public var internalIP: String = ""
    public var externalIP: String = ""
    public var bootVolume: String = ""
    public var diskSize: String = ""
    public var diskUsed: String = ""
    public var diskFree: String = ""
    public var uptime: String = ""
    public var terminalColumns: Int = 120
    public var supportsKitty: Bool = false
}

public enum InfoResult: Sendable {
    case user(String)
    case os(String)
    case hardware(chip: String, cores: String, memory: String)
    case machine(name: String, marketingModel: String?)
    case battery(String?)
    case internalIP(String)
    case externalIP(String)
    case disk(volumeName: String, size: String, used: String, free: String)
    case shell(String)
    case homebrew(available: Bool, installed: Int, outdated: Int)
    case uptime(String)
    case terminal(columns: Int, supportsKitty: Bool)
    case gpu(String?)
}

public struct SystemInfoBuilder: Sendable {
    public init() {}
    public var info = SystemInfo()

    public mutating func apply(_ result: InfoResult) {
        switch result {
        case let .user(name):
            info.userName = name
        case let .os(version):
            info.osVersion = version
        case let .hardware(chip, cores, memory):
            info.chipName = chip
            info.coreCount = cores
            info.memory = memory
        case let .machine(name, model):
            info.machineName = name
            info.marketingModel = model
        case let .battery(status):
            info.batteryStatus = status
        case let .internalIP(ip):
            info.internalIP = ip
        case let .externalIP(ip):
            info.externalIP = ip
        case let .disk(volume, size, used, free):
            info.bootVolume = volume
            info.diskSize = size
            info.diskUsed = used
            info.diskFree = free
        case let .shell(s):
            info.shell = s
        case let .homebrew(available, installed, outdated):
            info.homebrewAvailable = available
            info.homebrewInstalled = installed
            info.homebrewOutdated = outdated
        case let .uptime(u):
            info.uptime = u
        case let .terminal(cols, kitty):
            info.terminalColumns = cols
            info.supportsKitty = kitty
        case let .gpu(g):
            info.gpu = g
        }
    }

    public func build() -> SystemInfo {
        info
    }
}
