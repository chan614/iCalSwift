//
//  ICalPeriod.swift
//  
//
//

import Foundation

public struct ICalPeriod: VPropertyEncodable {
    public var startDate: Date
    public var endDate: Date
    
    public var vEncoded: String {
        let formatter = DateTimeUtil.dateFormatter(type: .period, tzid: nil)
        return formatter.string(from: startDate) + "/" + formatter.string(from: endDate)
    }
}
