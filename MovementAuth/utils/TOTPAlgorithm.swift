//
//  TOTPAlgorithm.swift
//  MovementAuth
//
//  Created by Fran on 12/03/21.
//

import Foundation
import SwiftOTP

class TOTPAlgorithm {
        
    static var TIME_INTERVAL = 30
    
    class func getTOTP(secretKey: String,
                       randomSeq: [String],
                       intervals: Int = Int(NSDate().timeIntervalSince1970)) -> String {
        var secret = secretKey.replacingOccurrences(of: randomSeq[0], with: randomSeq[1])
        secret = secretKey.replacingOccurrences(of: randomSeq[2], with: randomSeq[3])
        
        guard let data = base32DecodeToData(secret) else { return "ERROR" }
        if let totp = TOTP(secret: data,
                           digits: 6,
                           timeInterval: TIME_INTERVAL,
                           algorithm: .sha1) {
            let otpString = totp.generate(secondsPast1970: intervals)
            return otpString!
        }
        return ""
    }
        
    class func testAlgorithm() -> String {
        let SECRET_KEY = "MQ2TGZLEME3WCNRTG5RTSOLDMM3WMYRVGY3GIOJWMU4WMYJRGA4WEZRRGVRTINZYGQYTAYJTMY2WKYRUMQ2GGNDFGI3GGZBQHAYWMNQ="
        let RANDOM_SEQUENCE = ["1", "3", "A", "D"]
        //let TIME=240

        return getTOTP(secretKey: SECRET_KEY, randomSeq: RANDOM_SEQUENCE)
    }
}
