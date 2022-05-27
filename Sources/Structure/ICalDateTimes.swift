//
//  ICalDateTimes.swift
//  
//
//

import Foundation

public struct ICalDateTimes: VPropertyEncodable {
    public var type: DateValueType
    public var tzid: String?
    public var dates: [Date]
    public var periods: [ICalPeriod]?

    public var vEncoded: String {
        if type == .period, let periods = periods {
            return periods.map {
                let formatter = DateTimeUtil.dateFormatter(type: type, tzid: tzid)
                return formatter.string(from: $0.startDate) + "/" + formatter.string(from: $0.endDate)
            }
            .joined(separator: ",")
        } else {
            return dates
                .map { DateTimeUtil.dateFormatter(type: type, tzid: tzid).string(from: $0) }
                .joined(separator: ",")
        }
    }
    
    public var parameters: [ICalParameter] {
        DateTimeUtil.params(type: type, tzid: tzid)
    }

    private init(
        type: DateValueType,
        dates: [Date],
        tzid: String?,
        periods: [ICalPeriod]?
    ) {
        self.type = type
        self.dates = dates
        self.tzid = tzid
        self.periods = periods
    }

    public static func dateOnly(_ dates: [Date]) -> ICalDateTimes {
        ICalDateTimes(type: .date, dates: dates, tzid: nil, periods: nil)
    }
    
    public static func dateTime(_ dates: [Date], tzid: String? = nil) -> ICalDateTimes {
        ICalDateTimes(type: .dateTime, dates: dates, tzid: tzid, periods: nil)
    }

    public static func period(_ periods: [ICalPeriod], tzid: String? = nil) -> ICalDateTimes {
        ICalDateTimes(type: .period, dates: [], tzid: tzid, periods: periods)
    }
}
