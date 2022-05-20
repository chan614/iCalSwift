//
//  DateTimeUtil.swift
//  
//
//

import Foundation

struct DateTimeUtil {
    static func dateFormatter(type: DateValueType, tzid: String?) -> DateFormatter {
        let formatter = DateFormatter()
        
        formatter.timeZone = {
            if let tzid = tzid {
                return .init(identifier: tzid)
            } else {
                return .init(secondsFromGMT: 0)
            }
        }()
        
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
    
    static func params(type: DateValueType, tzid: String?) -> [(String, [String])] {
        let valueParam: (String, [String])? = {
            switch type {
            case .date:
                return ("VALUE", ["DATE"])
            case .dateTime:
                return nil
            case .period:
                return ("VALUE", ["PERIOD"])
            }
        }()
        
        let tzidParam: (String, [String])? = {
            if let tzid = tzid {
                return ("TZID", [tzid])
            } else {
                return nil
            }
        }()
        
        return [valueParam, tzidParam].compactMap { $0 }
    }
}
