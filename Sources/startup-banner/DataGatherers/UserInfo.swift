/*****************************************************************************************
 * UserInfo.swift
 *
 * Gather the current user's full name
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Feb-2026  3:00pm
 * Modified :
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/

import Foundation

public enum UserInfo {
    public static func gather() -> InfoResult {
        .user(NSFullUserName())
    }
}
