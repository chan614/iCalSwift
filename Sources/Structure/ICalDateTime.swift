//
//  ICalDateTime.swift
//  
//
//

import Foundation

public enum DateValueType: Equatable {
    case date
    case dateTime
    case period
}

/// A date or date/time for use in calendar
/// events, todos or free/busy-components.
public struct ICalDateTime: VPropertyEncodable {
    public var type: DateValueType
    public var tzid: String?
    public var date: Date

    public var vEncoded: String {
        DateTimeUtil.dateFormatter(type: type, tzid: tzid).string(from: date)
    }
    
    public var parameters: [(String, [String])] {
        DateTimeUtil.params(type: type, tzid: tzid)
    }

    public var isDateOnly: Bool {
        type == .date
    }
    
    init(type: DateValueType, date: Date, tzid: String?) {
        self.type = type
        self.date = date
        self.tzid = tzid
    }
    
    public static func dateOnly(_ date: Date) -> ICalDateTime {
        ICalDateTime(type: .date, date: date, tzid: nil)
    }
    
    public static func dateTime(_ date: Date, tzid: String? = nil) -> ICalDateTime {
        ICalDateTime(type: .dateTime, date: date, tzid: tzid)
    }
}
