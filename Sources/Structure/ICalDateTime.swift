//
//  ICalDateTime.swift
//  
//
//

import Foundation

/// A date or date/time for use in calendar
/// events, todos or free/busy-components.
public struct ICalDateTime: VPropertyEncodable {
    public static let dateOnlyFormat = "yyyyMMdd"
    public static let dtFormat = "yyyyMMdd'T'HHmmss"
    public static let utcFormat = "yyyyMMdd'T'HHmmss'Z'"
    
    public static let dateOnlyTZID = "DATE"
    public static let utcTZID = "UTC"
    
    public var date: Date
    public var timeZoneID: String

    public var vEncoded: String {
        let dateStr = Self.dateFormatter(timeZoneID: timeZoneID).string(from: date)
        return dateStr
    }
    
    public var parameters: [(String, [String])] {
        isDateOnly ? [("VALUE", ["DATE"])] : []
    }
    
    public var isDateOnly: Bool {
        return timeZoneID == Self.dateOnlyTZID
    }

    public init(date: Date, timeZoneID: String = utcTZID) {
        self.date = date
        self.timeZoneID = timeZoneID
    }
    
    public static func dateFormatter(timeZoneID: String) -> DateFormatter {
        let formatter = DateFormatter()
        
        let timeZone: TimeZone? = timeZoneID == Self.utcTZID
        ? TimeZone(identifier: timeZoneID)
        : TimeZone(secondsFromGMT: 0)
        
        formatter.timeZone = timeZone
        
        formatter.dateFormat = {
            if timeZoneID == Self.dateOnlyTZID {
                return ICalDateTime.dateOnlyFormat
            } else if timeZoneID == Self.utcTZID {
                return ICalDateTime.utcFormat
            } else {
                return ICalDateTime.dtFormat
            }
        }()
        
        return formatter
    }

    public static func dateOnly(_ date: Date) -> ICalDateTime {
        ICalDateTime(date: date, timeZoneID: dateOnlyTZID)
    }
    
    public static func utcTime(_ date: Date) -> ICalDateTime {
        ICalDateTime(date: date, timeZoneID: utcTZID)
    }

    public static func dateTime(_ date: Date, timeZoneID: String) -> ICalDateTime {
        ICalDateTime(date: date, timeZoneID: timeZoneID)
    }
}
