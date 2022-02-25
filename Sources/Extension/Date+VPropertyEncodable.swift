//
//  Date+VPropertyEncodable.swift
//  
//
//

import Foundation

extension Date: VPropertyEncodable {
    public var vEncoded: String {
        ICalendarDate(date: self).vEncoded
    }
}
