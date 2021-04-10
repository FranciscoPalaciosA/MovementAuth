//
//  TOTPAlgorithm.swift
//  MovementAuth
//
//  Created by Fran on 12/03/21.
//

import Foundation
import SwiftOTP

class TOTPAlgorithm {
        
    static var TIME_INTERVAL = 120
    
    class func getTOTP(secretKey: String,
                       randomSeq: [String],
                       intervals: Int = Int(NSDate().timeIntervalSince1970)) -> String {
        var secret = secretKey.replacingOccurrences(of: randomSeq[0], with: randomSeq[1])
        secret = secret.replacingOccurrences(of: randomSeq[2], with: randomSeq[3])
        
        //print("Secret = ", secret)
        //print("Random Seq = ", randomSeq)
        
        guard let data = base32DecodeToData(secret) else { return "ERROR" }
        if let totp = TOTP(secret: data,
                           digits: 6,
                           timeInterval: TIME_INTERVAL,
                           algorithm: .sha1) {
            let otpString = totp.generate(secondsPast1970: intervals)
            print("Full Time = ", intervals)
            return otpString!
        }
        return ""
    }
        
    class func testAlgorithm() -> String {
        let SECRET_KEY = "MM4TIYZXGFSTMMJXGEZDAYTGGQ4TGYJTGYYTMZLEMMZDEMJTGUZDIZJYMNSTCZLCGUZDKNTEMI2DAYRWGEYGIZRRG44TOY3GMJRDMOI="
        let RANDOM_SEQUENCE = ["F",
                               "Y",
                               "4",
                               "2"]
        //let TIME=240

        return getTOTP(secretKey: SECRET_KEY, randomSeq: RANDOM_SEQUENCE)
    }
}

