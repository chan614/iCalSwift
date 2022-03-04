//
//  ICalDuration.swift
//  
//
//

import Foundation

fileprivate let second: Int64 = 1
fileprivate let minute: Int64 = second * 60
fileprivate let hour: Int64 = minute * 60
fileprivate let day: Int64 = hour * 24
fileprivate let week: Int64 = day * 7

/// Specifies a positive duration of time.
///
/// See https://tools.ietf.org/html/rfc5545#section-3.8.2.5
public struct ICalDuration: VPropertyEncodable, AdditiveArithmetic {
    public static let zero: ICalDuration = ICalDuration(totalSeconds: 0)

    /// The total seconds of this day.
    public var totalSeconds: Int64

    public var parts: (weeks: Int, days: Int, hours: Int, minutes: Int, seconds: Int) {
        if totalSeconds % week == 0 {
            let weeks = totalSeconds / week
            return (weeks: Int(weeks), days: 0, hours: 0, minutes: 0, seconds: 0)
        }
        
        let days = totalSeconds / day
        let rest1 = totalSeconds % day
        let hours = rest1 / hour
        let rest2 = rest1 % hour
        let minutes = rest2 / minute
        let rest3 = rest2 % minute
        let seconds = rest3 / second

        return (weeks: 0, days: Int(days), hours: Int(hours), minutes: Int(minutes), seconds: Int(seconds))
    }
    
    public var vEncoded: String {
        var encodedDuration: String
        let (weeks, days, hours, minutes, seconds) = parts

        if totalSeconds % week == 0 {
            encodedDuration = "\(weeks)W"
        } else {
            encodedDuration = "\(days)DT\(hours)H\(minutes)M\(seconds)S"
        }

        return "\(totalSeconds >= 0 ? "" : "-")P\(encodedDuration)"
    }

    public init(totalSeconds: Int64 = 0) {
        self.totalSeconds = totalSeconds
    }

    public init(integerLiteral: Int64) {
        self.init(totalSeconds: integerLiteral)
    }
    
    public init(weeks: Int64, days: Int64, hours: Int64, minutes: Int64, seconds: Int64) {
        let weeksSec = weeks * week
        let daysSec = days * day
        let hoursSec = hours * hour
        let minutesSec = minutes * minute
        
        let totalSeconds = weeksSec + daysSec + hoursSec + minutesSec + seconds
        
        self.init(totalSeconds: totalSeconds)
    }

    public mutating func negate() {
        totalSeconds.negate()
    }

    public static prefix func -(operand: Self) -> Self {
        Self(totalSeconds: -operand.totalSeconds)
    }

    public static func +(lhs: Self, rhs: Self) -> Self {
        Self(totalSeconds: lhs.totalSeconds + rhs.totalSeconds)
    }

    public static func -(lhs: Self, rhs: Self) -> Self {
        Self(totalSeconds: lhs.totalSeconds - rhs.totalSeconds)
    }

    public static func weeks(_ weeks: Int) -> Self {
        Self(totalSeconds: Int64(weeks) * week)
    }

    public static func days(_ days: Int) -> Self {
        Self(totalSeconds: Int64(days) * day)
    }

    public static func hours(_ hours: Int) -> Self {
        Self(totalSeconds: Int64(hours) * hour)
    }

    public static func minutes(_ minutes: Int) -> Self {
        Self(totalSeconds: Int64(minutes) * minute)
    }
    
    public static func seconds(_ seconds: Int) -> Self {
        Self(totalSeconds: Int64(seconds) * second)
    }
}
