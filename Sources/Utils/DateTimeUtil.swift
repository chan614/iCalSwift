//
//  DateTimeUtil.swift
//  
//
//

import Foundation

struct DateTimeUtil {
    static func dateFormatter(type: DateValueType, tzid: String?) -> DateFormatter {
        let formatter = DateFormatter()
        
        if let tzid = tzid {
            formatter.timeZone = .init(identifier: tzid)
        } else if .date == type {
            formatter.timeZone = .current
        } else {
            formatter.timeZone = .init(abbreviation: "UTC")
        }
        
        formatter.dateFormat = {
            switch type {
            case .date:
                return Constant.Format.dateOnly
            case .dateTime, .period:
                return tzid == nil ? Constant.Format.utc : Constant.Format.dt
            }
        }()
        
        return formatter
    }
    
    static func params(type: DateValueType, tzid: String?) -> [ICalParameter] {
        let valueParam: ICalParameter? = {
            switch type {
            case .date:
                return .init(key: "VALUE", values: ["DATE"])
            case .dateTime:
                return nil
            case .period:
                return .init(key: "VALUE", values: ["PERIOD"])
            }
        }()
        
        let tzidParam: ICalParameter? = {
            if let tzid = tzid {
                return .init(key: "TZID", values: [tzid])
            } else {
                return nil
            }
        }()
        
        return [valueParam, tzidParam].compactMap { $0 }
    }
}
